

const { PrismaClient } = require('@prisma/client');
const { sendEmail } = require('../notifications/email'); 
const prisma = new PrismaClient();
const { io } = require('../server'); 
const { validateDescription } = require('../helpers/aiValidator'); 


// Get my claims
const getClaims = async (req, res) => {
  try {
    const claims = await prisma.claim.findMany({
      orderBy: { created_at: 'desc' },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            profile: {
              select: {
                id: true,
                first_name: true,
                last_name: true,
                phone: true,
                address: true,
              },
            },
          },
        },
        documents: true, 
      },
    });

    const claimsWithDownloadLinks = claims.map((claim) => {
      const documents = claim.documents.map((doc) => ({
        ...doc,
        download_url: `${req.protocol}://${req.get('host')}/uploads/${doc.file_name}`,
      }));

      return {
        ...claim,
        documents,
      };
    });

    res.json(claimsWithDownloadLinks);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error retrieving claims');
  }
};



// Create Claim

const createClaim = async (req, res) => {
  const {
    claim_type,
    incident_description,
    status = 'Pending',
    priority = 'Normal'
  } = req.body;

  const uploadedFile = req.file; 

  try {

    //Validate the description
    const aiResult = await validateDescription(incident_description);

    if (aiResult) {
      const { labels, scores } = aiResult;

      const labelScoreMap = labels.reduce((acc, label, idx) => {
        acc[label] = scores[idx];
        return acc;
      }, {});
      console.log('AI Validation Result:');
      console.log(labelScoreMap); 

      const isLikelyBad = labelScoreMap['unclear'] > 0.7 || labelScoreMap['incomplete'] > 0.6 || labelScoreMap['scam'] > 0.5;
    
      const isLikelyGood = labelScoreMap['detailed'] > 0.6 || labelScoreMap['insurance claim'] > 0.2;
    
    if (isLikelyBad || !isLikelyGood) {
      return res.status(400).json({
        message:
          'The claim description appears unclear, incomplete, or irrelevant. Please provide more details.',
      });
    }
      
    }
    
    const newClaim = await prisma.claim.create({
      data: {
        claim_type,
        incident_description,
        status,
        priority,
        user_id: req.user.id,
      },
    });

  
    if (uploadedFile) {
      await prisma.claimDocument.create({
        data: {
          file_name: uploadedFile.filename,
          claim_id: newClaim.id,
        },
      });
    }

    res.status(201).json(newClaim);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error creating claim');
  }
};



// View claim status
const viewClaimStatus = async (req, res) => {
  const { id } = req.params;

  try {
    const claim = await prisma.claim.findUnique({
      where: { id: Number(id) },
    });
    if (!claim) {
      return res.status(404).send('Claim not found');
    }
    res.json(claim);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error retrieving claim status');
  }
};

const updateClaimStatus = async (req, res) => {
  const { id } = req.params;
  const { status, review_comment } = req.body;

 
  if (!['Pending', 'Under_Review', 'Approved', 'Denied'].includes(status)) {
      return res.status(400).send('Invalid status');
  }

  try {
     
      const updated = await prisma.claim.update({
          where: { id: Number(id) },
          data: {
              status,
              reviewed_by: req.user.id,
              reviewed_at: new Date(),
              review_comment,
          },
          include: {
              user: true, 
          },
      });


      if (!updated.user) {
          return res.status(404).send('User not found for the claim');
      }

      // Emit the status update via socket.io using req.io
      if (req.io) {
          req.io.emit('claimStatusUpdated', updated);
      }

      // Send email notification to the claimant
      await sendEmail(
          // 'stephenlungo99@gmail.com',
          updated.user.email,
          `Claim ${updated.id} Status Update`,
          `Your claim with ID ${updated.id} has been ${status}. Comments: ${review_comment || 'No comments provided.'}`
      );

      res.json(updated);
  } catch (err) {
      console.error(err);
      res.status(500).send('Error updating claim status');
  }
};

  
// controllers/claimController.js

const settleClaim = async (req, res) => {
    const { id } = req.params;
    const { settlement_amount, payment_reference } = req.body;
    console.log('Incoming data:', { id, settlement_amount, payment_reference });
    try {
      const claim = await prisma.claim.findUnique({ where: { id: Number(id) } });
  
      if (!claim) return res.status(404).send('Claim not found');
      if (claim.status !== 'Approved') return res.status(400).send('Only approved claims can be settled');
  
      const updatedClaim = await prisma.claim.update({
        where: { id: Number(id) },
        data: {
          status: 'Settled',
          settlement_date: new Date(),
          settlement_amount,
          payment_reference,
        },
      });
  
      res.json(updatedClaim);
    } catch (err) {
      console.error(err);
      res.status(500).send('Error settling claim');
    }
  };
  
  
  // Get only the claims for the currently logged-in user
  const getMyClaims = async (req, res) => {
    const user_id = req.user.id;
  
    try {
      const myClaims = await prisma.claim.findMany({
        where: {
          user_id: user_id,
        },
        orderBy: {
          created_at: 'desc',
        },
        include: {
          documents: {
            select: {
              file_name: true,
            },
          },
        },
      });
  
     
      const claimsWithDocs = myClaims.map((claim) => {
        const documents = claim.documents.map((doc) => ({
          ...doc,
      
          download_url: `${req.protocol}://${req.get('host')}/uploads/${doc.file_name}`,
        }));
        return { ...claim, documents };
      });
  
      res.status(200).json(claimsWithDocs);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error fetching your claims' });
    }
  };
  
module.exports = {
  getClaims,
  createClaim,
  updateClaimStatus,
  viewClaimStatus,
  settleClaim,
  getMyClaims,
};

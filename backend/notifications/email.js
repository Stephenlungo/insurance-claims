const nodemailer = require('nodemailer');

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const sendEmail = async (recipient, subject, body) => {
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.EMAIL_USER, 
      pass: process.env.EMAIL_PASSWORD, 
    },
  });

  try {
  
    const info = await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: recipient,
      subject: subject,
      text: body,
    });

    await prisma.emailLog.create({
      data: {
        recipient: recipient,
        subject: subject,
        body: body,
        status: 'Sent',
        error_message: null,
      },
    });

    console.log('Email sent:', info.messageId);
  } catch (error) {
   
    await prisma.emailLog.create({
      data: {
        recipient: recipient,
        subject: subject,
        body: body,
        status: 'Failed',
        error_message: error.message,
      },
    });

    console.error('Error sending email:', error.message);
  }
};

module.exports = { sendEmail };

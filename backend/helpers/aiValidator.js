
const axios = require('axios');

const HUGGINGFACE_API_KEY = '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'; 

const validateDescription = async (description) => {
  try {
    const candidateLabels = ['insurance claim', 'scam', 'incomplete', 'unclear', 'detailed'];

    const response = await axios.post(
      'https://api-inference.huggingface.co/models/facebook/bart-large-mnli',
      {
        inputs: description,
        parameters: {
          candidate_labels: candidateLabels,
        },
      },
      {
        headers: {
          Authorization: `Bearer ${HUGGINGFACE_API_KEY}`,
        },
      }
    );

    const result = response.data;
    return result;
  } catch (error) {
    console.error('AI Validation Error:', error.message);
    return null;
  }
};

module.exports = { validateDescription };

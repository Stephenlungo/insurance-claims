# 🛡️ Insurance Claims System

This is a web-based prototype system for processing insurance claims. It includes both a React frontend and a Node.js + Express backend powered by PostgreSQL. The system also integrates an AI-based claim description validator using HuggingFace models.

## ✨ Features

- Claim registration and listing
- Admin approval/settlement workflow
- AI validation of claim descriptions for relevance and quality
- Responsive UI built with Material UI
- PostgreSQL database support

---

## 📦 Tech Stack

| Layer        | Tech                   |
|--------------|------------------------|
| Frontend     | React + Material UI    |
| Backend      | Node.js + Express      |
| Database     | PostgreSQL             |
| AI Validation| HuggingFace BART Model |
| Auth         | JWT                   |
| Web Socket.io| For Real-time communication |

---

## 🚀 Getting Started

### 🛠️ Prerequisites

- Node.js (v18+ recommended)
- PostgreSQL (configured and running)
- A HuggingFace API Key

### 📁 Folder Structure
root/ ├── frontend/ # React frontend ├── backend/ # Express backend └── README.md



### ⚙️ Setup Instructions

#### 1. Clone the Repository

### bash
git clone https://github.com/your-username/insurance-claim-system.git
cd insurance-claim-system

### ⚙ Backend Setup
cd backend

npm install

cp .env.example .env


PORT=5000
DATABASE_URL=postgresql://username:password@localhost:5432/yourdbname
HUGGINGFACE_API_KEY=your_huggingface_api_key


npm run dev

### ⚙ Frontend Setup

cd ../frontend

npm install

npm start



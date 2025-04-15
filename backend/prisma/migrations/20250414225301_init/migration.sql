-- CreateEnum
CREATE TYPE "ClaimStatus" AS ENUM ('Pending', 'Under_Review', 'Approved', 'Denied', 'Settled');

-- CreateEnum
CREATE TYPE "ClaimPriority" AS ENUM ('Normal', 'High');

-- CreateTable
CREATE TABLE "Claim" (
    "id" SERIAL NOT NULL,
    "claimant_name" TEXT NOT NULL,
    "claim_type" TEXT,
    "incident_description" TEXT,
    "status" "ClaimStatus" NOT NULL DEFAULT 'Pending',
    "priority" "ClaimPriority" NOT NULL DEFAULT 'Normal',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Claim_pkey" PRIMARY KEY ("id")
);

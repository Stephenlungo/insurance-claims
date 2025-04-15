/*
  Warnings:

  - Added the required column `user_id` to the `Claim` table without a default value. This is not possible if the table is not empty.
  - Made the column `claim_type` on table `Claim` required. This step will fail if there are existing NULL values in that column.
  - Made the column `incident_description` on table `Claim` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "Claim" ADD COLUMN     "user_id" INTEGER NOT NULL,
ALTER COLUMN "claim_type" SET NOT NULL,
ALTER COLUMN "incident_description" SET NOT NULL;

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "Claim" ADD CONSTRAINT "Claim_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

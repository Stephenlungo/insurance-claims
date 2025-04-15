/*
  Warnings:

  - You are about to drop the column `createdAt` on the `Claim` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `EmailLog` table. All the data in the column will be lost.
  - You are about to drop the column `errorMessage` on the `EmailLog` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `UserProfile` table. All the data in the column will be lost.
  - You are about to drop the column `profile_picture` on the `UserProfile` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `UserProfile` table. All the data in the column will be lost.
  - Added the required column `updated_at` to the `UserProfile` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Claim" DROP COLUMN "createdAt",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "EmailLog" DROP COLUMN "createdAt",
DROP COLUMN "errorMessage",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "error_message" TEXT;

-- AlterTable
ALTER TABLE "UserProfile" DROP COLUMN "createdAt",
DROP COLUMN "profile_picture",
DROP COLUMN "updatedAt",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

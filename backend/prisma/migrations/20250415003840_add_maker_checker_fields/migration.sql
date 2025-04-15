-- CreateEnum
CREATE TYPE "Role" AS ENUM ('maker', 'reviewer');

-- AlterTable
ALTER TABLE "Claim" ADD COLUMN     "review_comment" TEXT,
ADD COLUMN     "reviewed_at" TIMESTAMP(3),
ADD COLUMN     "reviewed_by" INTEGER;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "role" "Role" NOT NULL DEFAULT 'maker';

-- AddForeignKey
ALTER TABLE "Claim" ADD CONSTRAINT "Claim_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AlterTable
ALTER TABLE "Claim" ADD COLUMN     "payment_reference" TEXT,
ADD COLUMN     "settlement_amount" DOUBLE PRECISION,
ADD COLUMN     "settlement_date" TIMESTAMP(3);

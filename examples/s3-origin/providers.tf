provider "aws" {
  region = "ap-southeast-1"
  assume_role {
    role_arn = "arn:aws:iam::964323286598:role/PTAWSG_PROD_ENVIRONMENT_02_PROVISION_ROLE"
  }
  default_tags {
    tags = {
      Project_Code          = "COC-LAB"
      CostCenter            = "704D905153"
      ApplicationId         = "Common - COC"
      ApplicationName       = "COC Dedicated Account for Development"
      Environment           = "Development"
      DataClassification    = "Missing"
      SCAClassification     = "Missing"
      CSBIA_Confidentiality = "Missing"
      CSBIA_Integrity       = "Missing"
      CSBIA_Availability    = "Missing"
      CSBIA_ImpactScore     = "Missing"
      IACManaged            = "true"
      IACRepo               = "NA"
      ProductOwner          = "sazali.mokhtar@petronas.com.my"
      ProductSupport        = "InfraServices_COC_CloudOps@petronas.com.my"
      BusinessOwner         = "sazali.mokhtar@petronas.com.my"
      BusinessStream        = "PDnT"
      BusinessOPU_HCU       = "PETRONAS Digital Sdn Bhd"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "nvirginia"
  assume_role {
    role_arn = "arn:aws:iam::964323286598:role/PTAWSG_PROD_ENVIRONMENT_02_PROVISION_ROLE"
  }
  default_tags {
    tags = {
      Project_Code          = "COC-LAB"
      CostCenter            = "704D905153"
      ApplicationId         = "Common - COC"
      ApplicationName       = "COC Dedicated Account for Development"
      Environment           = "Development"
      DataClassification    = "Missing"
      SCAClassification     = "Missing"
      CSBIA_Confidentiality = "Missing"
      CSBIA_Integrity       = "Missing"
      CSBIA_Availability    = "Missing"
      CSBIA_ImpactScore     = "Missing"
      IACManaged            = "true"
      IACRepo               = "NA"
      ProductOwner          = "sazali.mokhtar@petronas.com.my"
      ProductSupport        = "InfraServices_COC_CloudOps@petronas.com.my"
      BusinessOwner         = "sazali.mokhtar@petronas.com.my"
      BusinessStream        = "PDnT"
      BusinessOPU_HCU       = "PETRONAS Digital Sdn Bhd"
    }
  }
}


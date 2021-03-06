PhyloBetaEntropy <-
function(NorP, NorPexp = NULL, q = 1, Tree, Normalize = TRUE, ...) 
{
  UseMethod("PhyloBetaEntropy")
}


PhyloBetaEntropy.ProbaVector <-
function(NorP, NorPexp = NULL, q = 1, Tree, Normalize = TRUE, ..., CheckArguments = TRUE, Ps = NULL, Pexp = NULL) 
{
  if (CheckArguments)
    CheckentropartArguments()
  
  if (missing(NorP)){
    if (!missing(Ps)) {
      NorP <- Ps
    } else {
      stop("An argument NorP or Ps must be provided.")
    }
  }
  if (missing(NorPexp)){
    if (!missing(Pexp)) {
      NorPexp <- Pexp
    } else {
      stop("An argument NorPexp or Pexp must be provided.")
    }
  }
  
  # Prepare NorP
  PandPexp <- matrix(c(NorP, NorPexp), nrow = length(NorP), ncol = 2, dimnames = list(names(NorP), c("Ps", "Pexp")))
  # Calculate the PhyloValue. Intermediate function is necessary to separate P and Pexp before calling TsallisBeta.ProbaVector
  Entropy <- PhyloApply(Tree, function(PandPexp, q, CheckArguments) TsallisBeta(PandPexp[, "Ps"], PandPexp[, "Pexp"], q, CheckArguments), PandPexp, Normalize, q=q, CheckArguments=FALSE)
  # Complete it
  Entropy$Function <- "PhyloBetaEntropy" 
  Entropy$Distribution <- c(ArgumentOriginalName(NorP), "compared to", ArgumentOriginalName(NorP))
  Entropy$Tree <- ArgumentOriginalName(Tree)
  Entropy$Type <- "beta"
  Entropy$Order <- q
  
  class(Entropy) <- c("PhyloEntropy", class(Entropy))
  
  return (Entropy)
}


PhyloBetaEntropy.AbdVector <-
function(NorP, NorPexp = NULL, q = 1, Tree, Normalize = TRUE, Correction = "Best", ..., CheckArguments = TRUE, Ns = NULL, Nexp = NULL) 
{
  if (missing(NorP)){
    if (!missing(Ns)) {
      NorP <- Ns
    } else {
      stop("An argument NorP or Ns must be provided.")
    }
  }
  if (missing(NorPexp)){
    if (!missing(Nexp)) {
      NorPexp <- Nexp
    } else {
      stop("An argument NorPexp or Nexp must be provided.")
    }
  }
  return(bcPhyloBetaEntropy(Ns=NorP, Nexp=NorPexp, q=q, Tree=Tree, Normalize=Normalize, Correction=Correction, CheckArguments=CheckArguments))
}


PhyloBetaEntropy.integer <-
function(NorP, NorPexp = NULL, q = 1, Tree, Normalize = TRUE, Correction = "Best", ..., CheckArguments = TRUE, Ns = NULL, Nexp = NULL) 
{
  if (missing(NorP)){
    if (!missing(Ns)) {
      NorP <- Ns
    } else {
      stop("An argument NorP or Ns must be provided.")
    }
  }
  if (missing(NorPexp)){
    if (!missing(Nexp)) {
      NorPexp <- Nexp
    } else {
      stop("An argument NorPexp or Nexp must be provided.")
    }
  }
  return (bcPhyloBetaEntropy(Ns=NorP, Nexp=NorPexp, q=q, Tree=Tree, Normalize=Normalize, Correction=Correction, CheckArguments=CheckArguments))
}


PhyloBetaEntropy.numeric <-
function(NorP, NorPexp = NULL, q = 1, Tree, Normalize = TRUE, Correction = "Best", ..., CheckArguments = TRUE, Ps = NULL, Ns = NULL, Pexp = NULL, Nexp = NULL) 
{
  if (missing(NorP)){
    if (!missing(Ps)) {
      NorP <- Ps
    } else {
      if (!missing(Ns)) {
        NorP <- Ns
      } else {
        stop("An argument NorP or Ps or Ns must be provided.")
      }
    }
  }
  if (missing(NorPexp)){
    if (!missing(Pexp)) {
      NorPexp <- Pexp
    } else {
      if (!missing(Nexp)) {
        NorP <- Nexp
      } else {
        stop("An argument NorPexp or Pexp or Nexp must be provided.")
      }
    }
  }
  
  if (abs(sum(NorP) - 1) < length(NorP)*.Machine$double.eps) {
    # Probabilities sum to 1, allowing rounding error
    return(PhyloBetaEntropy.ProbaVector(NorP, NorPexp, q=q, Tree=Tree, Normalize=Normalize, CheckArguments=CheckArguments))
  } else {
    # Abundances
    return (PhyloBetaEntropy.AbdVector(NorP, NorPexp, q=q, Tree=Tree, Normalize=Normalize, Correction=Correction, CheckArguments=CheckArguments))
  }
}


bcPhyloBetaEntropy <-
function(Ns, Nexp, q = 1, Tree, Normalize = TRUE, Correction = "Best", CheckArguments = TRUE) 
{
  if (CheckArguments)
    CheckentropartArguments()
  
  # Prepare NorP
  NandNexp <- matrix(c(Ns, Nexp), nrow = length(Ns), ncol = 2, dimnames = list(names(Ns), c("Ns", "Nexp")))
  #  Calculate the PhyloValue. Intermediate function is necessary to separate N and Nexp before calling bcTsallisBeta
  Entropy <- PhyloApply(Tree, function(NandNexp, q, Correction, CheckArguments) bcTsallisBeta(NandNexp[, "Ns"], NandNexp[, "Nexp"], q, Correction, CheckArguments), NandNexp, Normalize, q=q, Correction=Correction, CheckArguments=FALSE)
  # Complete it
  Entropy$Function <- "PhyloEntropy" 
  Entropy$Distribution <- ArgumentOriginalName(Ns)
  Entropy$Tree <- ArgumentOriginalName(Tree)
  Entropy$Type <- "beta"
  Entropy$Order <- q
  Entropy$Correction <- Correction
  
  class(Entropy) <- c("PhyloEntropy", class(Entropy))
  
  return (Entropy)
}

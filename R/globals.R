DATABASE_LABEL = "PubMed"
BASE_URL = "https://eutils.ncbi.nlm.nih.gov"
MAX_ENTRIES_PER_PAGE = 1000

utils::globalVariables("DATABASE_LABEL", "pubmedR", add = TRUE)
utils::globalVariables("BASE_URL", "pubmedR", add = TRUE)
utils::globalVariables("MAX_ENTRIES_PER_PAGE", "pubmedR", add = TRUE)
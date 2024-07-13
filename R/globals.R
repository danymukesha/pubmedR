DATABASE_LABEL = "PubMed"
BASE_URL = "https://eutils.ncbi.nlm.nih.gov"
MAX_ENTRIES_PER_PAGE = 1000

utils::globalVariables("DATABASE_LABEL", "pubmedr", add = TRUE)
utils::globalVariables("BASE_URL", "pubmedr", add = TRUE)
utils::globalVariables("MAX_ENTRIES_PER_PAGE", "pubmedr", add = TRUE)
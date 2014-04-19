# State of the Union Transcripts
# http://www.whitehouse.gov/state-of-the-union-2013
# http://www.presidency.ucsb.edu/sou.php

require(tm)        # corpus
require(SnowballC) # stemming
require(ggplot2)

# Explore Sources #####
# getSources()
# getReaders()

# Create Corpus #####
# Many of these options are not required, but
# I want to show them to you.

sotu_source <- DirSource(
    # indicate directory
    directory = file.path("sotu"),
    encoding = "UTF-8",     # encoding
    pattern = "*.txt",      # filename pattern
    recursive = FALSE,      # visit subdirectories?
    ignore.case = FALSE)    # ignore case in pattern?

sotu_corpus <- Corpus(
    sotu_source, 
    readerControl = list(
        reader = readPlain, # read as plain text
        language = "en"))   # language is english

# Inspect Corpus #####
# print(sotu_corpus)
# summary(sotu_corpus)
# inspect(sotu_corpus)
# sotu_corpus[["sotu2013.txt"]]

# Transform Corpus #####
# getTransformations()
# sotu_corpus[[1]][3]

sotu_corpus <- tm_map(sotu_corpus, tolower)

sotu_corpus <- tm_map(
    sotu_corpus, 
    removePunctuation,
    preserve_intra_word_dashes = TRUE)

sotu_corpus <- tm_map(
    sotu_corpus, 
    removeWords, 
    stopwords("english"))

# getStemLanguages()
sotu_corpus <- tm_map(
    sotu_corpus, 
    stemDocument,
    lang = "porter") # try porter or english

sotu_corpus <- tm_map(
    sotu_corpus, 
    stripWhitespace)

# Remove specific words
sotu_corpus <- tm_map(
    sotu_corpus, 
    removeWords, 
    c("will", "can", "get", "that", "year", "let"))

# print(sotu_corpus[["sotu2013.txt"]][3])

# Calculate Frequencies
sotu_tdm <- TermDocumentMatrix(sotu_corpus)

# Inspect Frequencies
# print(sotu_tdm)
# inspect(sotu_tdm[40:44,])
# findFreqTerms(sotu_tdm, 20)
# inspect(sotu_tdm[findFreqTerms(sotu_tdm, 20),])

# Convert to term/frequency format
sotu_matrix <- as.matrix(sotu_tdm)
sotu_df <- data.frame(
    word = rownames(sotu_matrix), 
    # necessary to call rowSums if have more than 1 document
    freq = rowSums(sotu_matrix),
    stringsAsFactors = FALSE) 

# Sort by frequency
sotu_df <- sotu_df[with(
    sotu_df, 
    order(freq, decreasing = TRUE)), ]

# Do not need the row names anymore
rownames(sotu_df) <- NULL

# Check out final data frame
# View(sotu_df)

# Create a data frame comparing 2012 and 2014
freq_df <- data.frame(
    sotu1961 = sotu_matrix[, "1961.txt"],
    sotu1962 = sotu_matrix[, "1962.txt"],
    stringsAsFactors = FALSE)

rownames(freq_df) <- rownames(sotu_matrix)

# Filter out infrequent words
# freq_df <- freq_df[rowSums(freq_df) > 30,]

# Alternatively, just look at top 15
freq_df <- freq_df[order(
    rowSums(freq_df), 
    decreasing = TRUE),]

freq_df <- head(freq_df, 15)

# Plot frequencies
p <- ggplot(freq_df, aes(sotu1961, sotu1962))

p <- p + geom_text(
    label = rownames(freq_df),
    position = position_jitter(
        width = 2,
        height = 2))

p <- p + xlab("Year 1961") + ylab("Year 1962")+theme_bw()+theme(axis.ticks.x=element_blank())+theme(axis.ticks.y=element_blank())
p <- p + ggtitle("State of the Union")+ theme( axis.title.x = element_text(colour="grey20",size=20,face="bold"),
     axis.title.y = element_text(colour="grey20",size=20,face="bold"), plot.title = element_text(colour="blue",size=24,face="bold"))
p <- p + scale_x_continuous(expand = c(0, 0))
p <- p + scale_y_continuous(expand = c(0, 0))
p <- p + coord_fixed(
    ratio = 1, 
    xlim = c(0, 50),
    ylim = c(0, 50))

print(p)

#ggsave(
#    filename = file.path("img", "sotu_freq.pdf"),
#    width = 6,
#    height = 4,
#    dpi = 100
#)


require(wordcloud) # word cloud

wordcloud(
    sotu_df$word,
    sotu_df$freq,
    scale = c(0.5, 6),      # size of words
    min.freq = 10,          # drop infrequent
    max.words = 30,         # max words in plot
    random.order = FALSE,   # plot by frequency
    rot.per = 0.3,          # percent rotated
    # set colors
    # colors = brewer.pal(9, "GnBu")
    colors = brewer.pal(12, "Paired"),
    # color random or by frequency
    random.color = TRUE,
    # use r or c++ layout
    use.r.layout = FALSE    
)

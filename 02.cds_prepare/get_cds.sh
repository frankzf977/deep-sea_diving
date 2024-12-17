## obtain cds, pep as well as geneLOC file 
perl Getfa_gbff.pl *.rna.gbff.gz species_id

## select the longest transcript of the gene 
perl Select_longest.pl species_id.geneLOC species_id.cds>longest.cds

##translated into pep
perl cds2aa.pl longest.cds>longest.pep
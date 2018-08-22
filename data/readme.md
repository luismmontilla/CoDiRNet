-------------------
GENERAL INFORMATION
-------------------


1. Title of Dataset: CoDiRNet v1:

2. Author Information

  * Montilla, L. M. Universidad Simón Bolívar. luismmontilla@usb.ve
  * Ascanio, A. Universidad Simón Bolívar. ascanio.alfredoa@gmail.com | 11-10060@usb.ve
  * Verde, A. Universidad Simón Bolívar. averde@usb.ve
  * Cróquer, A. Universidad Simón Bolívar. acroquer@usb.ve

--------------------------
SHARING/ACCESS INFORMATION
--------------------------

1. Licenses/restrictions placed on the data:

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/80x15.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

2. Was data derived from another source?: Yes, you can check the complete list of papers in:
https://github.com/luismmontilla/CoDiRNet/blob/master/supplementary/papers_included_codirnet.bib


3. Recommended citation for the data:




---------------------
DATA & FILE OVERVIEW
---------------------


1. File List:

  * Filename: *master_codirnet.csv*        

    * Short description: Topics associated to each paper included in the network.
  * Filename: *glossary_codirnet.csv*        

    * Short description: List of all the topics used for the construction of the network. Column 1 corresponds to the name of the node, and column 2 is the designation to one of four possible categories: Disease, Genus, Ecoregion, or Topic.


2. Relationship between files: All the nodes included in *master_codirnet.csv* should appear listed in *glossary_codirnet.csv*. A verification of this is included in the file *codirnet.Rmd*.


3. Additional related data collected that was not included in the current data package: The collection of included papers is listed in the *supplementary* directory of the present compendium.

4. Are there multiple versions of the dataset?: No

--------------------------
METHODOLOGICAL INFORMATION
--------------------------


1. Description of methods used for collection/generation of data:
<Include links or references to publications or other documentation containing experimental design or protocols used in data collection>


2. Methods for processing the data: The complete analysis is included in the *analysis* directory of the present compendium.

3. Instrument- or software-specific information needed to interpret the data:

R Core Team (2018). R: A language and environment for statistical computing. R
Foundation for Statistical Computing, Vienna, Austria. URL
https://www.R-project.org/

4. People involved with sample collection, processing, analysis and/or submission:

  * Montilla, L. M. Universidad Simón Bolívar. luismmontilla@usb.ve
  * Ascanio, A. Universidad Simón Bolívar. ascanio.alfredoa@gmail.com | 11-10060@usb.ve
  * Verde, A. Universidad Simón Bolívar. averde@usb.ve




-----------------------------------------
DATA-SPECIFIC INFORMATION FOR: *master_codirnet.csv*
-----------------------------------------

1. Number of variables: 24

2. Number of cases/rows: 720

3. Variable List:

  * authors: An arbitrary id referencing the authors of the paper.
 * year: Year of publication of the paper.
 * journal: Journal of publication of the paper.
 * doi: When existing, digital object identifier assigned to the paper.
  * node: topics assigned to the paper, additional nodes are included as additional columns.

-----------------------------------------
DATA-SPECIFIC INFORMATION FOR: *glossary_codirnet.csv*
-----------------------------------------

1. Number of variables: 2

2. Number of cases/rows: 303

3. Variable List:

  * node: Name assigned to the node
 * attribute: One of following categories assigned to the node.
    * Disease.
    * Genus.
    * Ecoregion.
    * Topic.

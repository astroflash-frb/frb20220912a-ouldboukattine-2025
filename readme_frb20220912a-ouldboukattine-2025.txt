!!!!!!!!!!!!!!
!!! Code can be retrieved via the following SURFdrive link: https://surfdrive.surf.nl/files/index.php/s/Ea63fbKdzE9bFJV
!!!!!!!!!!!!!!

This repository contains the scripts and databases used to generate the plots and results presented in Ould-Boukattine 2025.

Files:

    conda-env-analysis-OB2025.yml:
    YAML file to reproduce the Python environment for the analysis.

    Bash scripts (.sh):
    Scripts used to generate and prepare filterbank files and archive files used in the analysis.

Folders:

    ./dbs:
    The databases are stored in ./dbs/ and are structured as follows:
        Full information on all burst components: burst_stats_r117.csv
        Raw format of burst energies as quoted in Table X of the paper: FRB20220912A_table_paper.csv

    Additionally, we include burst properties from other referenced works:
        FAST: ./dbs/FRB20220912A-Table.csv (Zhang et al. 2023)
        Allen Telescope Array (ATA): ./dbs/allen-telescope/table_allen.csv (Sheikh et al. 2024)
        Nançay Radio Telescope (NRT): ./dbs/fixed_fluences_NRT.csv (Konijn et al. 2024)

    ./flags:
    Flag files for each burst used for zapping radio frequency interference (RFI).

    ./plots:
    Folder containing all plots in .pdf and/or .png format.

    ./python:
    Relevant Python scripts and Jupyter Notebook code used to analyze the data and generate the plots. Each file includes relevant comments.

    ./spc:
    Bash script used to execute the SPC algorithm on .archive files, as described in the Methods section.

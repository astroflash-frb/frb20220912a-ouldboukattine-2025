# ReadMe

This repository contains the scripts and databases used to generate the plots and results presented in [Ould-Boukattine+2025](https://arxiv.org/abs/2410.17024).
The data is hosted at Zenodo can be retrieved [here](https://doi.org/10.5281/zenodo.11261763).

Software used:

    The pipeline written to process and search the baseband data can be found at [frb-baseband](https://github.com/pharaofranz/frb-baseband). 
    software used to transfer radio data can be found at [jive5ab](https://github.com/jive-vlbi/jive5ab), 
    The burst searcher software can be found at [Heimdall](https://sourceforge.net/projects/heimdall-astro/) 
    The burst classifier software FETCH is be found [here](https://github.com/devanshkv/fetch) 
    The pulsar package DSPSR is hosted at [here](https://sourceforge.net/projects/dspsr/) and {\tt SIGPROC} can be retrieved from [here](https://github.com/SixByNine/sigproc).
    The source code for the MCMC analysis is based on this [example](https://philuttley.github.io/stats-methods-24/12-mcmc/index.html)
    
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

If you used this code or any of the tools, please cite [Ould-Boukattine+2025](https://arxiv.org/abs/2410.17024)  in your work.

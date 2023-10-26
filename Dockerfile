# syntax=docker/dockerfile:1

## to avoid installing the entire FSL package, we will use the conda version of the single program bet
FROM condaforge/miniforge3
ENV PATH="/opt/conda/bin:${PATH}"

COPY /run /usr/local/run
RUN chmod +x /usr/local/run

## install conda-forge and bet from FSL public repository
#RUN /opt/conda/bin/conda install -n base -c conda-forge tini ##debugging
RUN /opt/conda/bin/conda install -n base -c https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/public fsl-bet2 -c conda-forge
ENV FSLDIR="/opt/conda"


## XNAT container service
LABEL org.nrg.commands="[{\"name\": \"fsl-bet\", \"description\": \"Runs FSL Brain Extraction Tool\", \"label\": \"fsl-bet\", \"version\": \"1.0\", \"schema-version\": \"1.0\", \"type\": \"docker\", \"image\": \"fsl-bet-xnat\", \"command-line\": \"/usr/local/run /input /output [SCAN_NAME] [OTHER_FLAGS]\", \"mounts\": [{\"name\": \"nifti-in\", \"writable\": \"false\", \"path\": \"/input\"}, {\"name\": \"nifti-out\", \"writable\": \"true\", \"path\": \"/output\"}], \"environment-variables\": {}, \"ports\": {}, \"inputs\": [{\"name\": \"scan-name\", \"description\": \"Name of image to feed to FSL's bet\", \"type\": \"string\", \"default-value\": null, \"required\": true, \"replacement-key\": \"[SCAN_NAME]\", \"select-values\": []}, {\"name\": \"other-flags\", \"description\": \"Other flags to pass to FSL's bet\", \"type\": \"string\", \"required\": false, \"default-value\": null, \"replacement-key\": \"[OTHER_FLAGS]\"}], \"outputs\": [{\"name\": \"extracted-brain\", \"description\": \"The brain extracted image from bet\", \"mount\": \"nifti-out\", \"required\": true, \"path\": \"extract\"}], \"xnat\": [{\"name\": \"fsl-bet\", \"description\": \"Run FSL Brain Extraction Tool on scan\", \"label\": \"fsl-bet\", \"contexts\": [\"xnat:imageScanData\"], \"external-inputs\": [{\"name\": \"scan-name\", \"description\": \"Input scan\", \"type\": \"Scan\", \"required\": true, \"matcher\": \"'NIFTI' in @.resources[*].label\", \"via-setup-command\": null, \"user-settable\": null, \"load-children\": true}], \"derived-inputs\": [{\"name\": \"scan-nifti\", \"description\": \"The nifti resource of the scan\", \"type\": \"Resource\", \"derived-from-wrapper-input\": \"scan\", \"provides-files-for-command-mount\": \"nifti-in\", \"matcher\": \"@.label == 'NIFTI'\"}], \"output-handlers\": [{\"name\": \"brain-resource\", \"accepts-command-output\": \"extracted-brain\", \"as-a-child-of-wrapper-input\": \"scan\", \"type\": \"Resource\", \"label\": \"BRAIN\"}]}]}]"
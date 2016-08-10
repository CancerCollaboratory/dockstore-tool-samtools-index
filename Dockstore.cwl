#!/usr/bin/env cwl-runner

class: CommandLineTool

description: |
  Prints alignments in the specified input alignment file.

  Usage: samtools index [-bc] [-m INT] <in.bam> aln.bam|aln.cram
  Options:
    -b       Generate BAI-format index for BAM files [default]
    -c       Generate CSI-format index for BAM files
    -m INT   Set minimum interval size for CSI indices to 2^INT [14]

  For a CRAM file aln.cram, index file aln.cram.crai will be created. For a BAM file aln.bam, either aln.bam.bai or aln.bam.csi will be created, depending on the index format selected.

cwlVersion: draft-3

dct:contributor:
  foaf:name: Andy Yang
  foaf:mbox: "mailto:ayang@oicr.on.ca"

dct:creator:
  "@id": "http://orcid.org/0000-0001-9102-5681"
  foaf:name: "Andrey Kartashov"
  foaf:mbox: "mailto:Andrey.Kartashov@cchmc.org"

dct:description: "Developed at Cincinnati Children’s Hospital Medical Center for the CWL consortium http://commonwl.org/ Original URL: https://github.com/common-workflow-language/workflows"


requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cancercollaboratory/dockstore-tool-samtools-index"
  - class: InlineJavascriptRequirement
    expressionLib:
    - "var new_ext = function() { var ext=inputs.bai?'.bai':inputs.csi?'.csi':'.bai'; return inputs.input.path.split('/').slice(-1)[0]+ext; };"

inputs:
- id: "#input"
  type: File
  description: |
    Input bam file.
  inputBinding:
    position: 2

- id: "#bai"
  type: boolean
  default: false
  description: |
    Generate BAI-format index for BAM files [default]

- id: "#csi"
  type: boolean
  default: false
  description: |
    Generate CSI-format index for BAM files

- id: "#interval"
  type: ["null", int]
  description: |
    Set minimum interval size for CSI indices to 2^INT [14]
  inputBinding:
    position: 1
    prefix: "-m"

outputs:
  - id: "#index"
    type: File
    description: "The index file"
    outputBinding:
      glob: $(new_ext())

baseCommand: ["samtools", "index"]

arguments:
  - valueFrom: $(inputs.bai?'-b':inputs.csi?'-c':[])
    position: 1
  - valueFrom: $(new_ext())
    position: 3


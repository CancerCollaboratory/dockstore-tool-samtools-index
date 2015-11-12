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

dct:contributor:
  foaf:name: Andy Yang
  foaf:mbox: "mailto:ayang@oicr.on.ca"

dct:creator:
  "@id": "http://orcid.org/0000-0001-9102-5681"
  foaf:name: "Andrey.Kartashov / Cincinnati Children’s Hospital Medical Center"
  foaf:mbox: "mailto:Andrey.Kartashov@cchmc.org"

dct:description: "Developed for CWL consortium http://commonwl.org/ Original URL: https://github.com/common-workflow-language/workflows"


requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cancercollaboratory/dockstore-tool-samtools-index"
  - { import: node-engine.cwl }

inputs:
  - id: "#input"
    type: File
    description: |
      Input bam file.
    inputBinding:
      position: 4

  - id: "#fakeoutput"
    type: string
    default: ""
    inputBinding:
      position: 6
      valueFrom:
        engine: node-engine.cwl
        script: |
          {
            var ext=$job['bai']?'.bai':$job['csi']?'.csi':'.bai';
            return $job['input'].path.split('/').slice(-1)[0]+ext;
          }

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
      Generate CSI-format index for BAM files
    inputBinding:
      position: 1
      prefix: "-m"

outputs:
  - id: "#sorted"
    type: File
    description: "The sorted file"
    outputBinding:
      glob:
        engine: node-engine.cwl
        script: |
          {
            var ext=$job['bai']?'.bai':$job['csi']?'.csi':'.bai';
            return $job['input'].path.split('/').slice(-1)[0]+ext;
          }

baseCommand: ["samtools", "index"]

arguments:
  - valueFrom:
      engine: node-engine.cwl
      script: |
        $job['bai']?'-b':$job['csi']?'-c':[]


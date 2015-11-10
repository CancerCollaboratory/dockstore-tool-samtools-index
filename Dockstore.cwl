#!/usr/bin/env cwl-runner

class: CommandLineTool

description: |
  Prints alignments in the specified input alignment file.

  Usage: samtools index [-bc] [-m INT] <in.bam> [out.index]
  Options:
    -b       Generate BAI-format index for BAM files [default]
    -c       Generate CSI-format index for BAM files
    -m INT   Set minimum interval size for CSI indices to 2^INT [14]

dct:creator:
  foaf:name: Andy Yang
  foaf:mbox: "mailto:ayang@oicr.on.ca"

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cancercollaboratory/dockstore-tool-samtools-view"
  - { import: node-engine.cwl }

inputs:
  - id: "#input"
    type: File
    description: |
      Input bam file.
    inputBinding:
      position: 4

  - id: "#region"
    type: ["null",string]
    description: |
      [region ...]
    inputBinding:
      position: 5

  - id: "#output_name"
    type: string
    inputBinding:
      position: 2
      prefix: "-o"

  - id: "#isbam"
    type: boolean
    default: false
    description: |
      output in BAM format
    inputBinding:
      position: 2
      prefix: "-b"

  - id: "#iscram"
    type: boolean
    default: false
    description: |
      output in CRAM format
    inputBinding:
      position: 2
      prefix: "-C"

  - id: "#fastcompression"
    type: boolean
    default: false
    description: |
      use fast BAM compression (implies -b)
    inputBinding:
      position: 1
      prefix: "-1"

  - id: "#uncompressed"
    type: boolean
    default: false
    description: |
      uncompressed BAM output (implies -b)
    inputBinding:
      position: 1
      prefix: "-u"

  - id: "#samheader"
    type: boolean
    default: false
    description: |
      include header in SAM output
    inputBinding:
      position: 1
      prefix: "-h"

  - id: "#count"
    type: boolean
    default: false
    description: |
      print only the count of matching records
    inputBinding:
      position: 1
      prefix: "-c"

  - id: "#referencefasta"
    type: ["null",File]
    description: |
      reference sequence FASTA FILE [null]
    inputBinding:
      position: 1
      prefix: "-T"

  - id: "#bedoverlap"
    type: ["null",File]
    description: |
      only include reads overlapping this BED FILE [null]
    inputBinding:
      position: 1
      prefix: "-L"

  - id: "#readsingroup"
    type: ["null",string]
    description: |
      only include reads in read group STR [null]
    inputBinding:
      position: 1
      prefix: "-r"

  - id: "#readsingroupfile"
    type: ["null",File]
    description: |
      only include reads with read group listed in FILE [null]
    inputBinding:
      position: 1
      prefix: "-R"

  - id: "#readsquality"
    type: ["null",int]
    description: |
      only include reads with mapping quality >= INT [0]
    inputBinding:
      position: 1
      prefix: "-q"

  - id: "#readsinlibrary"
    type: ["null",string]
    description: |
      only include reads in library STR [null]
    inputBinding:
      position: 1
      prefix: "-l"

  - id: "#cigar"
    type: ["null",int]
    description: |
      only include reads with number of CIGAR operations
      consuming query sequence >= INT [0]
    inputBinding:
      position: 1
      prefix: "-m"

  - id: "#readswithbits"
    type: ["null",int]
    description: |
      only include reads with all bits set in INT set in FLAG [0]
    inputBinding:
      position: 1
      prefix: "-f"

  - id: "#readswithoutbits"
    type: ["null",int]
    description: |
      only include reads with none of the bits set in INT set in FLAG [0]
    inputBinding:
      position: 1
      prefix: "-F"

  - id: "#readtagtostrip"
    type:
      - "null"
      - type: array
        items: string
    description: |
      read tag to strip (repeatable) [null]

  - id: "#collapsecigar"
    type: boolean
    default: false
    description: |
      collapse the backward CIGAR operation
    inputBinding:
      position: 1
      prefix: "-B"

  - id: "#randomseed"
    type: ["null",float]
    description: |
      integer part sets seed of random number generator [0];
      rest sets fraction of templates to subsample [no subsampling]
    inputBinding:
      position: 1
      prefix: "-s"

  - id: "#threads"
    type: ["null",int]
    description: |
      number of BAM compression threads [0]
    inputBinding:
      position: 1
      prefix: "-@"

outputs:
  - id: "#output"
    type: File
    outputBinding:
      glob:
        engine: cwl:JsonPointer
        script: /job/output_name

baseCommand: ["samtools", "view"]

arguments:
  - valueFrom:
      engine: node-engine.cwl
      script: |
        { if ($job['readtagtostrip'])
            $job['readtagtostrip'].map(function(i) {return "-x"+i;});
          else return [];
        }


version 1.0


import "../tasks/awk.wdl"
import "../tasks/bedops.wdl"


workflow get_chrom_sizes {
    input {
        BedopsSortBedParams params = object {}
        File fai
        Resources resources
    }

    String chrom_sizes_output = basename(fai, ".fa.fai") + ".chrom_sizes.bed"

    call awk.convert_fai_to_bed_format {
        input:
            fai=fai,
            resources=resources,
    }

    call bedops.sort_bed {
        input:
            out=chrom_sizes_output,
            params=params,
            resources=resources,
            unsorted_bed=convert_fai_to_bed_format.bed,
    }

    output {
        File chrom_sizes = sort_bed.sorted_bed
    }
}

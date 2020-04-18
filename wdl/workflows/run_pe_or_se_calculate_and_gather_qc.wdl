version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/structs/hotspot2.wdl"
import "calculate_and_gather_pe_qc.wdl" as pe_bams_and_peaks
import "calculate_and_gather_se_qc.wdl" as se_bams_and_peaks


workflow run_pe_or_se_calculate_and_gather_qc {
    input {
        QCFilesCalculate files_for_calculation
        QCFilesGather files_to_gather
        Replicate replicate
        MachineSizes machine_sizes
    }

    Boolean paired_only = (
        defined(replicate.pe_fastqs)
        && !defined(replicate.se_fastqs)
    )

    if (paired_only) {
        call pe_bams_and_peaks.calculate_and_gather_pe_qc {
            input:
                files_for_calculation=files_for_calculation,
                files_to_gather=files_to_gather,
                machine_sizes=machine_sizes,
        }
    }

    if (!paired_only) {
        call se_bams_and_peaks.calculate_and_gather_se_qc {
            input:
                files_for_calculation=files_for_calculation,
                files_to_gather=files_to_gather,
                machine_sizes=machine_sizes,
        }
    }

    output {
        QC out = select_first([
            calculate_and_gather_pe_qc.out,
            calculate_and_gather_se_qc.out
        ])
    }
}
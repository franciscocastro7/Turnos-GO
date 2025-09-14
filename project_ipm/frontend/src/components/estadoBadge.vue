<template>
    <span :class="badgeClasses" class="inline-flex justify-center items-center px-3 py-1 rounded-lg font-bold 
             text-sm sm:text-base 
             w-full sm:w-[140px] 
             min-h-7 sm:h-7 
             leading-none
             ">
        <div class="flex items-center gap-2">
            <span :class="dotClasses" class="w-3 h-3 sm:w-4 sm:h-4 rounded-full"></span>
            <span class="whitespace-nowrap leading-none">{{ estado }}</span>
        </div>
    </span>
</template>



<script>
export default {
    name: "EstadoBadge",
    props: {
        estado: {
            type: String,
            required: true,
        }
    },
    computed: {
        badgeClasses() {
            const estadoL = this.estado.toLowerCase();
            if (estadoL === "pendente") {
                return "bg-[#FFF4D6] text-[#825f05]";
            }
            if (estadoL === "deferido") {
                return "bg-[#C8FFD3] text-[#1E7D33]";
            }
            if (estadoL === "indeferido") {
                return "bg-[#FFC2C8] text-[#ac2626]";
            }
            return "bg-gray-300 text-gray-700";
        },
        dotClasses() {
            const estadoL = this.estado.toLowerCase();
            if (estadoL === "pendente") {
                return "bg-[#825f05]";
            }
            if (estadoL === "deferido") {
                return "bg-[#1E7D33]";
            }
            if (estadoL === "indeferido") {
                return "bg-[#ac2626]";
            }
            return "bg-gray-500";
        }
    }
}
</script>

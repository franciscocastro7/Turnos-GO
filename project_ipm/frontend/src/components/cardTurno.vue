<template>
    <div class="w-[288px] h-[150px] bg-[#EB5E28]/70 text-white rounded-2xl font-bold px-4 flex flex-col justify-between shadow-lg">
        <h1 class="text-center font-bold text-lg py-1.5">{{ `${uc.length > 20 ? abbreviation : uc}`  }}</h1>
        <div class="bg-white py-0.5"></div>

        <div class="flex flex-col items-center gap-1 text-base py-2">
            <div class="flex items-center gap-2 text-xl font-semibold">
                <Notebook class="w-5 h-5" />
                <span class="font-bold">{{ tipo }}</span>
                <Hourglass class="w-5 h-5" />
                <span>{{ horario }}</span>
            </div>

            <div class="flex items-center gap-2 text-xl font-semibold">
                <MapPin class="w-5 h-5" />
                <span>{{ sala }}</span>
            </div>

            <div class="flex items-center gap-2 text-xl font-semibold">
                <GraduationCap class="w-5 h-5" />
                <span>{{ ano }}</span>
            </div>
        </div>
    </div>
</template>

<script setup>
import { Notebook, Hourglass, MapPin, GraduationCap } from 'lucide-vue-next';

defineProps({
    uc: {
        type: String,
        required: true
    },
    abbreviation: {
        type: String,
        required: true
    },
    tipo: {
        type: String,
        required: true
    },
    horario: {
        type: String,
        required: true
    },
    sala: {
        type: String,
        required: true
    },
    ano: {
        type: String,
        required: true
    }
});
</script>
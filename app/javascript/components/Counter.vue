<template lang="">
    <div>
        <button @click="increment" id="counter-button">Increment</button>
        <p>Count is: {{ count }}</p>
    </div>
</template>
<script>
export default {
    data() {
        return {
            count: 0
        }
    },
    methods: {
        increment() {
            this.count++
        }
    }
}
</script>
<style lang="css">
    #counter-button {
        background-color: #4CAF50;
        border: none;
        color: white;
        padding: 15px 32px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 16px;
        border-radius: 5px;
    }

    #counter-button:hover {
        background-color: #3e8e41;
        cursor: pointer;
    }
</style>
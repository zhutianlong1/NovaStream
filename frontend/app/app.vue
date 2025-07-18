<template>
  <div>
    <button @click="testPing">测试Ping接口</button>
    <NuxtRouteAnnouncer />
    <NuxtWelcome />
  </div>
</template>
<script setup>
async function testPing() {
  try {
    const data = await $fetch('/api/ping', { method: 'GET' })
    // 假设返回为 { msg: 'xxx' }
    console.log('Ping接口返回: ' + (data.msg ?? '无数据'))
  } catch (e) {
    console.log('Ping接口调用失败: ' + e)
  }
}
</script>

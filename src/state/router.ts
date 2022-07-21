import { reactive } from "vue"

export const route = reactive({
  page: "roadmap",
  params: {} as any,
})

export const goTo = (key: { page: string; params?: any }) => {
  route.page = key.page
  route.params = key.params
}

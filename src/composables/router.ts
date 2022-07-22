import { watch, shallowReactive } from "vue"

const route = shallowReactive({
  page: "category",
  params: { category: "bugs" } as any,
})

const oldRoute = shallowReactive({
  page: "",
  params: {} as any,
})

watch(
  () => [route.page, route.params],
  ([newPage, newParams], [oldPage, oldParams]) => {
    if (newPage !== oldPage) {
      oldRoute.params = oldParams
      oldRoute.page = oldPage
    }
  }
)

export const useRouter = () => {
  const goTo = (key: { page: string; params?: any }) => {
    route.page = key.page
    route.params = key.params
  }

  return {
    route,
    oldRoute,
    goTo,
  }
}

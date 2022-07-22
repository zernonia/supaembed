import { Status } from "./interface"

export const computedStatusClass = (status: string) => {
  switch (status) {
    case Status["under review"]: {
      return "text-gray-500 bg-gray-100"
    }
    case Status["planned"]: {
      return "text-blue-500 bg-blue-100"
    }
    case Status["in progress"]: {
      return "text-orange-500 bg-orange-100"
    }
    case Status["live"]: {
      return "text-green-500 bg-green-100"
    }
  }
}

export interface User {
  id: string
  avatar?: string
  name?: string
}

export interface Post {
  id: string
  user_id: string
  title: string
  description?: string
  slug: string
  created_at: Date
  category: string
  status?: string
  vote_count?: number
  comment_count?: number
  active_for_user?: boolean
  user: User
}

export interface Comment {
  id: string
  created_at: Date
  post_id: string
  parent_id: string
  user_id: string
  post: Post
  user: User
  comment: string
  child?: Comment[]
}

import Foundation
import FirebaseDatabase
import FirebaseDatabase

let databaseRef = Database.database().reference()

// Constants for Firebase Realtime Database nodes
let NODE_GROUPS = "Groups"
let NODE_MADRICHS = "Madrichs"
let NODE_STUDENTS = "Students"
let NODE_GUARDS = "Guards"
let NODE_EP = "ExitPermissions"

// Constants for Firebase Realtime Database child keys
let CHILD_ID = "id"

let CHILD_EXIT_DATE = "exitDate"
let CHILD_EXIT_TIME = "exitTime"
let CHILD_RETURN_DATE = "returnDate"
let CHILD_RETURN_TIME = "returnTime"
let CHILD_ACTUAL_RETURN_DATE = "actualReturnDate"
let CHILD_ACTUAL_RETURN_TIME = "actualReturnTime"

let CHILD_STATUS = "status"
let CHILD_DESTINATION = "destination"
let CHILD_GROUP = "group"
let CHILD_MADRICH_ID = "madrich_id"
let CHILD_MADRICH_NAME = "madrich_name"
let CHILD_STUDENT_ID = "student_id"
let CHILD_STUDENT_NAME = "student_name"
let CHILD_CONFIRMATION_LINK = "confirmationLink"
let CHILD_PROFILE_IMAGE = "profile_image_url"

let CHILD_STUDENTS = "students"

let CHILD_EXIT_PERMISSIONS = "exit_permissions"

let CHILD_NAME = "name"

// Constants for Firebase Storage
let STORAGE_PROFILE_IMAGES = "profile_images"

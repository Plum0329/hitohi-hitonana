import { application } from "./application"
import ReadingValidationController from "./reading_validation_controller"
application.register("reading-validation", ReadingValidationController)
import ContentValidationController from "./content_validation_controller"
application.register("content-validation", ContentValidationController)
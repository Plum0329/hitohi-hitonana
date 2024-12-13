import { application } from "./application"
import ReadingValidationController from "./reading_validation_controller"
import ContentValidationController from "./content_validation_controller"
import TextDirectionController from "./text_direction_controller"

application.register("reading-validation", ReadingValidationController)
application.register("content-validation", ContentValidationController)
application.register("text-direction", TextDirectionController)
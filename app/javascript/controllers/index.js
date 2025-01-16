import { application } from "./application"
import ReadingValidationController from "./reading_validation_controller"
import ContentValidationController from "./content_validation_controller"
import TextDirectionController from "./text_direction_controller"
import BackController from "./back_controller"
import FormStateController from "./form_state_controller"

application.register("reading-validation", ReadingValidationController)
application.register("content-validation", ContentValidationController)
application.register("text-direction", TextDirectionController)
application.register("back", BackController)
application.register("form-state", FormStateController)
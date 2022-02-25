
source("prepare_questions_data.R")

survey_qns <- import_json_for_shinysurvey()

# Launch survey --------------------------------------------------------------
ui <- fluidPage(
  surveyOutput(df = survey_qns,
               survey_title = "Sweet Summer Child Score (SSCS)",
               survey_description = "SSCS is a scoring mechanism for latent risk. It will help you quickly and efficiently scan for the possibility of harm to people and communities by a socio-technical system. Note that harms to animals and the environment are not considered.")
)

server <- function(input, output, session) {
  renderSurvey()
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Congrats, you completed your first shinysurvey!",
      "You can customize what actions happen when a user finishes a survey using input$submit."
    ))
  })
}

shinyApp(ui, server)

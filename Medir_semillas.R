# Definir el directorio de trabajo
setwd("C:/Users/INIA/Downloads/Semillas/R")

# Cargar las librerías necesarias
library(pliman)
library(tidyverse)
library(openxlsx)

# Crear un data frame vacío para almacenar los resultados
resultados <- data.frame(Imagen = character(), Numero_Semillas = integer(), stringsAsFactors = FALSE)

# Iterar sobre las imágenes desde Semilla_1.jpg hasta Semilla_100.jpg
for (i in 1:100) {
  # Generar el nombre del archivo
  nombre_imagen <- paste0("Semilla_", i, ".jpg")
  
  # Importar la imagen
  img <- image_import(nombre_imagen, plot = FALSE) # Cambiar plot a FALSE para evitar gráficos durante la iteración
  
  # Analizar los objetos en la imagen
  count <- analyze_objects(img, show_segmentation = FALSE, show_contour = FALSE, marker = "id")
  
  # Obtener el número total de objetos detectados (semillas)
  total_seeds <- count$statistics$value[count$statistics$stat == "n"]
  
  # Agregar los resultados al data frame
  resultados <- resultados %>% 
    add_row(Imagen = nombre_imagen, Numero_Semillas = total_seeds)
}

# Exportar los resultados a un archivo Excel
write.xlsx(resultados, "Resultados_Semillas.xlsx")

cat("Análisis completado y resultados exportados en 'Resultados_Semillas.xlsx'.")

# Medir morfologia de la semillas
# Cargar las bibliotecas necesarias
library(pliman)
library(tidyverse)
library(metan)
library(openxlsx)

# Crear una lista para almacenar los resultados
all_measures <- list()

# Bucle para procesar cada imagen desde Arb_37_1 hasta Arb_37_25
for (i in 1:100) {
  # Crear el nombre de archivo con el número correspondiente
  file_name <- paste0("Semilla_", i, ".jpg")
  
  # Importar la imagen
  img <- image_import(file_name, plot = FALSE)
  
  # Analizar los objetos en la imagen
  img_res <- analyze_objects(img, marker = "id")
  
  # Obtener las medidas y transponer
  measures <- get_measures(img_res, id = 2, area ~ 4) |> t()
  
  # Extraer solo las medidas de interés
  selected_measures <- measures[c("area", "perimeter", "length", "width"), , drop = FALSE]
  
  # Convertir a data.frame y añadir el nombre del archivo como identificador
  selected_measures_df <- as.data.frame(t(selected_measures))
  selected_measures_df$image <- file_name
  
  # Añadir el resultado a la lista
  all_measures[[i]] <- selected_measures_df
}

# Combinar todos los resultados en un solo data.frame
final_results <- bind_rows(all_measures)

# Especificar el nombre del archivo Excel
output_file <- "Medidas_Semilla.xlsx"

# Exportar los datos a Excel
write.xlsx(final_results, file = output_file)

# Mensaje de confirmación
print(paste("Medidas exportadas exitosamente a", output_file))



$ErrorActionPreference = "Stop"

# =========================================
# UBICACION DEL REPOSITORIO
# =========================================

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$projectsFile = Join-Path $root "projects.html"
$workFile = Join-Path $root "work.html"
$imagesFolder = Join-Path $root "images"


Write-Host ""
Write-Host "========================================="
Write-Host "   AGREGAR NUEVO PROYECTO"
Write-Host "========================================="
Write-Host ""


# =========================================
# COMPROBAR QUE EXISTEN LOS ARCHIVOS
# =========================================

if (!(Test-Path $projectsFile)) {
    Write-Host "ERROR: No encuentro projects.html"
    exit
}

if (!(Test-Path $workFile)) {
    Write-Host "ERROR: No encuentro work.html"
    exit
}

if (!(Test-Path $imagesFolder)) {
    Write-Host "ERROR: No encuentro la carpeta images"
    exit
}


# =========================================
# LEER PROJECTS.HTML Y WORK.HTML
# =========================================

$projectsHtml = [System.IO.File]::ReadAllText($projectsFile)
$workHtml = [System.IO.File]::ReadAllText($workFile)


# =========================================
# COMPROBAR MARCAS DE INSERCION
# =========================================

if (!$projectsHtml.Contains("<!-- AUTO:PROJECTS -->")) {

    Write-Host ""
    Write-Host "ERROR:"
    Write-Host "Falta esta marca en projects.html:"
    Write-Host ""
    Write-Host "<!-- AUTO:PROJECTS -->"
    Write-Host ""
    Write-Host "Debe estar antes del proyecto mas reciente."
    exit
}


if (!$workHtml.Contains("<!-- AUTO:WORK-CARDS -->")) {

    Write-Host ""
    Write-Host "ERROR:"
    Write-Host "Falta esta marca en work.html:"
    Write-Host ""
    Write-Host "<!-- AUTO:WORK-CARDS -->"
    Write-Host ""
    Write-Host "Debe estar antes de la primera tarjeta."
    exit
}


# =========================================
# CALCULAR AUTOMATICAMENTE LA NUEVA SERIE
# =========================================

$matches = [regex]::Matches(
    $projectsHtml,
    'id="serie-(\d+)"'
)

$numbers = @()

foreach ($match in $matches) {
    $numbers += [int]$match.Groups[1].Value
}


if ($numbers.Count -gt 0) {

    $maxSerie = ($numbers | Measure-Object -Maximum).Maximum
    $serieNumber = [int]$maxSerie + 1

}
else {

    $serieNumber = 1

}


Write-Host "Nueva serie que se creara: serie-$serieNumber"
Write-Host ""


# =========================================
# DATOS DEL PROYECTO
# =========================================

$serieLabel = Read-Host "Serie (ej: SERIE URBAINE c. 2026)"

$building = Read-Host "Nombre del edificio"

$architect = Read-Host "Arquitecto / autores / ano"

$location = Read-Host "Ciudad, Pais"


# =========================================
# PEDIR FOTOS DEL PROYECTO
# =========================================

Write-Host ""
Write-Host "Escribe las fotos del proyecto separadas por comas."
Write-Host ""
Write-Host "Ejemplo:"
Write-Host ""
Write-Host "DSCF9803.jpg,DSCF9800.jpg,DSCF9801.jpg,DSCF9802.jpg"
Write-Host ""

$imageInput = Read-Host "Fotos"


$requestedImages = @(
    $imageInput.Split(",") |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -ne "" }
)


if ($requestedImages.Count -eq 0) {

    Write-Host ""
    Write-Host "ERROR: No escribiste ninguna foto."
    exit

}


# =========================================
# CREAR LISTA DE IMAGENES EXISTENTES
# =========================================

$imageFiles = Get-ChildItem $imagesFolder -File

$imageMap = @{}

foreach ($file in $imageFiles) {
    $imageMap[$file.Name] = $file.Name
}


# =========================================
# COMPROBAR LAS FOTOS DEL PROYECTO
# =========================================

$actualImages = @()

foreach ($requested in $requestedImages) {

    if (!$imageMap.ContainsKey($requested)) {

        Write-Host ""
        Write-Host "========================================="
        Write-Host "ERROR"
        Write-Host "========================================="
        Write-Host ""
        Write-Host "No encuentro esta imagen en /images:"
        Write-Host ""
        Write-Host $requested
        Write-Host ""
        Write-Host "Revisa el nombre del archivo."
        exit

    }

    $actualImages += $imageMap[$requested]

}


# =========================================
# PEDIR FOTO PARA LA TARJETA DE GALLERY
# =========================================

Write-Host ""
Write-Host "-----------------------------------------"
Write-Host "FOTO PARA LA TARJETA DE GALLERY"
Write-Host "-----------------------------------------"
Write-Host ""
Write-Host "Escribe directamente el nombre exacto."
Write-Host ""
Write-Host "Ejemplo:"
Write-Host "DSCF9802.jpg"
Write-Host ""

$coverInput = (Read-Host "Foto para Gallery").Trim()


if (!$imageMap.ContainsKey($coverInput)) {

    Write-Host ""
    Write-Host "========================================="
    Write-Host "ERROR"
    Write-Host "========================================="
    Write-Host ""
    Write-Host "No encuentro esta imagen en /images:"
    Write-Host ""
    Write-Host $coverInput
    Write-Host ""
    exit

}


$coverImage = $imageMap[$coverInput]


# =========================================
# CREAR HTML DE LAS IMAGENES
# =========================================

$imageLines = ""

foreach ($image in $actualImages) {

    $imageLines += "        <img src=`"images/$image`" alt=`"`">`r`n"

}


# =========================================
# CREAR NUEVO BLOQUE PARA PROJECTS.HTML
# =========================================

$projectBlock = @"

<div class="work-series">

  <button class="work-arrow left" onclick="previousProject(this)">
    &#8249;
  </button>


  <main class="work-slider">

    <section id="serie-$serieNumber" class="work-project">

      <div class="work-images">
$imageLines
      </div>

    </section>

  </main>


  <button class="work-arrow right" onclick="nextProject(this)">
    &#8250;
  </button>


  <p class="work-caption">

    <span class="series-label">$serieLabel</span>

    $building<br>
    $architect<br>
    $location

  </p>

</div>

"@


# =========================================
# CREAR TARJETA PARA WORK.HTML
# =========================================

$workBlock = @"

  <a class="work-card" href="projects.html#serie-$serieNumber">
    <img src="images/$coverImage" alt="">
  </a>

"@


# =========================================
# CREAR BACKUP FUERA DEL REPOSITORIO
# =========================================

$parentFolder = Split-Path -Parent $root

$backupFolder = Join-Path `
    $parentFolder `
    "agustinandorno.github.io-backups-auto"


if (!(Test-Path $backupFolder)) {

    New-Item `
        -ItemType Directory `
        -Path $backupFolder |
        Out-Null

}


$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"


Copy-Item `
    $projectsFile `
    (Join-Path $backupFolder "projects-$timestamp.html")


Copy-Item `
    $workFile `
    (Join-Path $backupFolder "work-$timestamp.html")


# =========================================
# INSERTAR PROYECTO NUEVO AL PRINCIPIO
# =========================================

$projectsHtml = $projectsHtml.Replace(

    "<!-- AUTO:PROJECTS -->",

    "<!-- AUTO:PROJECTS -->" + $projectBlock

)


# =========================================
# INSERTAR TARJETA NUEVA AL PRINCIPIO
# =========================================

$workHtml = $workHtml.Replace(

    "<!-- AUTO:WORK-CARDS -->",

    "<!-- AUTO:WORK-CARDS -->" + $workBlock

)


# =========================================
# GUARDAR EN UTF-8
# =========================================

$utf8 = New-Object System.Text.UTF8Encoding($false)


[System.IO.File]::WriteAllText(
    $projectsFile,
    $projectsHtml,
    $utf8
)


[System.IO.File]::WriteAllText(
    $workFile,
    $workHtml,
    $utf8
)


# =========================================
# RESULTADO
# =========================================

Write-Host ""
Write-Host "========================================="
Write-Host "   PROYECTO AGREGADO CORRECTAMENTE"
Write-Host "========================================="
Write-Host ""

Write-Host "Proyecto creado:"
Write-Host "serie-$serieNumber"

Write-Host ""

Write-Host "Foto utilizada en Gallery:"
Write-Host $coverImage

Write-Host ""

Write-Host "Se modificaron:"
Write-Host " - projects.html"
Write-Host " - work.html"

Write-Host ""

Write-Host "Backup guardado en:"
Write-Host $backupFolder

Write-Host ""

Write-Host "IMPORTANTE:"
Write-Host "Abre primero el sitio local y comprueba"
Write-Host "que todo se vea correctamente."

Write-Host ""

Write-Host "Si esta bien, publica utilizando:"
Write-Host "publicar.bat"

Write-Host ""
allprojects {
    repositories {
        google()
        mavenCentral()
        // Нативная часть Tesseract (cz.adaptech.tesseract4android) публикуется
        // только здесь — в Maven Central её нет. Опубликованный плагин
        // прописывал этот репозиторий сам, залезая в корневой проект;
        // правильнее объявить его тут, у приложения.
        maven { url = uri("https://jitpack.io") }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

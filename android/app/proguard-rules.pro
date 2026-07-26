# Tesseract и Leptonica вызываются через JNI: имена классов и методов
# должны остаться как есть, иначе нативная часть их не найдёт.
-keep class com.googlecode.tesseract.android.** { *; }
-keep class com.googlecode.leptonica.android.** { *; }
-keep class io.paratoner.tesseract_ocr.** { *; }

# Isar тоже ходит в нативную библиотеку.
-keep class dev.isar.** { *; }

# Обычные предупреждения о ненайденных классах Play Core: их нет
# в сборке, и они не нужны.
-dontwarn com.google.android.play.core.**

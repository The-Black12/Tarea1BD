create database SistemaAcademico;
USE SistemaAcademico;

-- Crear la tabla departamento
CREATE TABLE IF NOT EXISTS departamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Crear la tabla estudiantes
CREATE TABLE IF NOT EXISTS estudiantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    departamento_id INT,
    FOREIGN KEY (departamento_id) REFERENCES departamento(id)
);

-- Crear la tabla curso
CREATE TABLE IF NOT EXISTS curso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos INT NOT NULL
);

-- Crear la tabla clase
CREATE TABLE IF NOT EXISTS clase (
    id INT AUTO_INCREMENT PRIMARY KEY,
    curso_id INT,
    horario VARCHAR(20),
    FOREIGN KEY (curso_id) REFERENCES curso(id)
);

-- Crear la tabla inscripcion
CREATE TABLE IF NOT EXISTS inscripcion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT,
    clase_id INT,
    fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (clase_id) REFERENCES clase(id)
);

-- Crear la tabla calificacion
CREATE TABLE IF NOT EXISTS calificacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inscripcion_id INT,
    nota DECIMAL(5, 2),
    FOREIGN KEY (inscripcion_id) REFERENCES inscripcion(id)
);

-- Insertar datos de ejemplo (opcional, para probar las consultas)
INSERT INTO departamento (nombre) VALUES ('Informática'), ('Matemáticas'), ('Física');
INSERT INTO estudiantes (nombre, apellido, email, departamento_id) VALUES
    ('Juan', 'Pérez', 'juan.perez@example.com', 1),
    ('María', 'Gómez', 'maria.gomez@example.com', 1),
    ('Carlos', 'López', 'carlos.lopez@example.com', 2),
    ('Ana', 'Martínez', 'ana.martinez@example.com', 2),
    ('Luis', 'Rodríguez', 'luis.rodriguez@example.com', 3);
INSERT INTO curso (nombre, creditos) VALUES ('Introducción a la Programación', 4), ('Cálculo I', 5), ('Física Básica', 4), ('Estructuras de Datos', 4), ('Álgebra Lineal', 3);
INSERT INTO clase (curso_id, horario) VALUES (1, 'L-X 10:00'), (1, 'M-J 14:00'), (2, 'M-J 08:00'), (3, 'V 11:00'), (4, 'L-V 16:00'), (5, 'M-J 18:00');
INSERT INTO inscripcion (estudiante_id, clase_id) VALUES (1, 1), (1, 3), (2, 1), (2, 2), (3, 4), (4, 5), (5, 6), (5,1);
INSERT INTO calificacion (inscripcion_id, nota) VALUES (1, 90), (2, 85), (3, 78), (4, 92), (5, 65), (6, 88), (7, 95), (8,100);

-- Consultas básicas y avanzadas

-- 1. Mostrar el nombre y apellido de todos los estudiantes ordenados por apellido
SELECT nombre, apellido FROM estudiantes ORDER BY apellido ASC;

-- 2. Mostrar todos los cursos que tienen más de 3 créditos
SELECT * FROM curso WHERE creditos > 3;

-- 3. Mostrar el nombre del estudiante y el nombre del curso en el que está inscrito
SELECT e.nombre AS estudiante, c.nombre AS curso
FROM inscripcion i
INNER JOIN estudiantes e ON i.estudiante_id = e.id
INNER JOIN clase cl ON i.clase_id = cl.id
INNER JOIN curso c ON cl.curso_id = c.id;

-- 4. Mostrar todos los estudiantes y, si están inscritos, el curso correspondiente
SELECT e.nombre, e.apellido, c.nombre AS curso
FROM estudiantes e
LEFT JOIN inscripcion i ON e.id = i.estudiante_id
LEFT JOIN clase cl ON i.clase_id = cl.id
LEFT JOIN curso c ON cl.curso_id = c.id;

-- 5. Mostrar todos los cursos, incluyendo los que aún no tienen estudiantes inscritos
SELECT c.nombre, COUNT(i.id) AS inscripciones
FROM curso c
LEFT JOIN clase cl ON c.id = cl.curso_id
LEFT JOIN inscripcion i ON cl.id = i.clase_id
GROUP BY c.nombre;

-- 6. Contar cuántos estudiantes hay por departamento
SELECT d.nombre AS departamento, COUNT(e.id) AS cantidad_estudiantes
FROM departamento d
LEFT JOIN estudiantes e ON d.id = e.departamento_id
GROUP BY d.id;

-- 7. Calcular el promedio de notas por estudiante
SELECT e.nombre, e.apellido, AVG(COALESCE(ca.nota, 0)) AS promedio
FROM estudiantes e
LEFT JOIN inscripcion i ON e.id = i.estudiante_id
LEFT JOIN calificacion ca ON i.id = ca.inscripcion_id
GROUP BY e.id;

-- 8. Mostrar la nota máxima y mínima por clase
SELECT cl.id AS clase_id, MAX(COALESCE(ca.nota, 0)) AS nota_maxima, MIN(COALESCE(ca.nota, 0)) AS nota_minima
FROM clase cl
LEFT JOIN inscripcion i ON cl.id = i.clase_id
LEFT JOIN calificacion ca ON i.id = ca.inscripcion_id
GROUP BY cl.id;

-- 9. Mostrar los 5 estudiantes con el mayor promedio de notas
SELECT e.nombre, e.apellido, AVG(ca.nota) AS promedio
FROM calificacion ca
INNER JOIN inscripcion i ON ca.inscripcion_id = i.id
INNER JOIN estudiantes e ON i.estudiante_id = e.id
GROUP BY e.id
ORDER BY promedio DESC
LIMIT 5;

-- Actualizar y eliminar

-- 10. Cambiar el correo electrónico de un estudiante
UPDATE estudiantes
SET email = 'nuevoemail@example.com'
WHERE id = 1;

-- 11. Eliminar una inscripción de un estudiante
DELETE FROM inscripcion WHERE id = 1;

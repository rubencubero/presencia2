const express = require("express");
const dateFormat = require("dateformat");
const mysql = require("mysql2/promise");

let db = null;
const app = express();
const port = 8001;

app.use(express.json());

app.post('/registrar', async(req, res, next)=>{
  const values = req.body.values;
  logInfo('Registrar entrada: INSERT INTO presencia (idpersona, idpdt, idpda, inicio,fin, idtlogin, idtlogout, observaciones, DATA, TIME,USER) VALUES (' + values + ');');

  await db.query("INSERT INTO presencia (idpersona, idpdt, idpda, inicio,fin, idtlogin, idtlogout, observaciones, DATA, TIME,USER) VALUES (" + values + ");");

  res.json({status:"OK"});
  next();
});

app.post('/cerrar_parte', async(req, res, next)=>{
  const values = req.body.values;
  logInfo('Registrar salida: ' + values );
  await db.query(values);
  res.json({status:"OK"});
  next();
});

app.get('/personas/:puntoAcceso', async (req, res, next) => {
  logInfo('Id punto acceso: ' + req.params.puntoAcceso);
  //const [rows] = await db.query("SELECT id,idtarjeta,descri,pwd FROM persona WHERE fecbaja ='' OR fecbaja IS null ORDER BY id;");
  const [rows] = await db.query("SELECT p.id,p.idtarjeta,p.descri,p.pwd " +
                                "FROM persona p LEFT JOIN persona_pdt pp ON pp.idpersona = p.id " +
                                "LEFT JOIN puesto_trabajo pt ON pt.id = pp.idpdt " +
                                "LEFT JOIN pt_ptoacc ON pt_ptoacc.idpdt = pt.id " +
                                "LEFT JOIN punto_acceso pa ON pt_ptoacc.idpto = pa.id " +
                                "WHERE (p.fecbaja ='' OR p.fecbaja IS NULL) AND pa.id = " + req.params.puntoAcceso + " " +
                                "GROUP BY p.id " +
                                "ORDER BY p.descri;");
  logInfo('Consulta ejecutada');
  res.json(rows);  
  next();
});

app.get('/parte_activo/:userID', async (req, res, next) => {      
  logInfo('Buscar parte activo de usuario: ' + req.params.userID);
  const [rows] = await db.query("SELECT id FROM presencia WHERE idpersona = " + req.params.userID + " AND (fin ='' OR fin IS null);");
  if (rows.length > 0){
    logInfo('- Resultado: ' + rows[0].id);
  }else{
    logInfo('No hay parte activo');
  }
  
  res.json(rows); 
  next();
});

setInterval( async function (){
  logInfo('Cierre de partes desde sistema.');
  await cerrarPartesDesdeSistema();
  
  /*const [rows] = await db.query('SELECT pr.id, ' +
                                'TIMESTAMPDIFF(HOUR, ' + 
                                'CONCAT(SUBSTR(pr.inicio,1,4),"-", SUBSTR(pr.inicio,5,2),"-", SUBSTR(pr.inicio,7,2)," ", SUBSTR(pr.inicio,10,2),":", SUBSTR(pr.inicio,12,2),":", SUBSTR(pr.inicio,14,2)), ' +
                                'CURRENT_TIMESTAMP ' +
                                ') AS horas ' +
                                'FROM presencia pr WHERE  (fin = "" OR fin IS NULL) GROUP BY pr.id HAVING horas > 15;');
  console.debug('Partes para cerrar... [' + rows.length + ']');
  for (i=0;i<rows.length;i++){
    cerrarParte(rows[i].id, 284, 'Inform??tica: Cierre autom??tico por 16 horas');
  }*/
}, 360000);

async function cerrarPartesDesdeSistema(){  
  //Partes duplicados
  [rows] = await getPartesDuplicados();
  logInfo('- Partes duplicados para cerrar... [' + rows.length + ']');
  for (i=0;i<rows.length;i++){
    cerrarParte(rows[i].id, 284, 'Inform??tica: Registro duplicado');
  }
  [rows] = [];

  //Partes sin cerrar
  [rows] = await getPartesSinCerrar();
  logInfo('- Partes sin cerrar... [' + rows.length + ']');
  for (i=0;i<rows.length;i++){
    logInfo(rows[i].id + ' | ' + rows[i].timestamp + ' | ' + rows[i].horas);
    cerrarParte(rows[i].id, 284, 'Inform??tica: Cierre autom??tico por 16 horas');
  }
  [rows] = [];
}

async function getPartesSinCerrar(){
  return await db.query('SELECT pr.id,CURRENT_TIMESTAMP as timestamp, ' +
                                'TIMESTAMPDIFF(HOUR, ' + 
                                'CONCAT(SUBSTR(pr.inicio,1,4),"-", SUBSTR(pr.inicio,5,2),"-", SUBSTR(pr.inicio,7,2)," ", SUBSTR(pr.inicio,10,2),":", SUBSTR(pr.inicio,12,2),":", SUBSTR(pr.inicio,14,2)), ' +
                                'CURRENT_TIMESTAMP ' +
                                ') AS horas ' +
                                'FROM presencia pr WHERE  (fin = "" OR fin IS NULL) GROUP BY pr.id HAVING horas > 15;');
}

async function getPartesDuplicados(){  return await db.query('SELECT MAX(id) AS id, COUNT(id) as contador FROM presencia WHERE (fin = "" OR fin IS NULL) GROUP BY idpersona, inicio HAVING contador > 1 ORDER BY id ASC;');}

async function cerrarParte(id, tipo, observacion){
  logInfo('- Cerrando parte');
  logInfo("UPDATE presencia SET fin = '" + dateFormat(Date.now(), "yyyymmdd hhMMss") + "', idtlogout = " + tipo + ", observaciones = '" + observacion + "' WHERE id = " + id + ";");
  const result = await db.query("UPDATE presencia SET fin = '" + dateFormat(Date.now(), "yyyymmdd hhMMss") + 
                                "', idtlogout = " + tipo 
                                + ", observaciones = '" + observacion + "' " 
                                + ", DATA = '" + dateFormat(Date.now(), "yyyy-mm-dd") + "'" 
                                + ", TIME = '" + dateFormat(Date.now(), "hh:MM:ss") + "'" 
                                + " WHERE id = " + id + ";");
  logInfo('- Resultado: ' + result.affectedRows + ' fila(s) actualizadas.');
}

app.get('/time', async (req, res) => {      
  console.debug('Fecha - Hora: ' + dateFormat(Date.now(), "yyyyMMdd hhMMss"));
  res.send('Fecha - Hora: ' + dateFormat(Date.now(), "yyyyMMdd hhMMss"));
});

function getCurrentDate() {
  return dateFormat(Date.now(), "yyyy-mm-dd hh:MM:ss");
};

function logInfo(mensaje){
  console.log('[' + getCurrentDate() + '] ' + mensaje);
};

async function main(){
  db = await mysql.createConnection({
    host:"192.168.123.229",
    user: "aspdev",
    password: "11972702",
    database: "eadeptlito"
    //database: "bp_pruebas"
  });

  const server = app.listen(port, () => console.log(`App listening on port: ${port}`));
  server.keepAliveTimeout = 61 * 1000;
  server.headersTimeout = 65 * 1000;
 
  console.info('Server status: ' + server.status);
}

main();


/*app.use((req, res, next) => {
  const error = new Error("Not found");
  error.status = 404;
  next(error);
});

// error handler middleware
app.use((error, req, res, next) => {
    res.status(error.status || 500).send({
      error: {
        status: error.status || 500,
        message: error.message || 'Internal Server Error',
      },
    });
  });
*/

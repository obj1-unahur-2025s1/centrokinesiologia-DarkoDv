class Paciente {
  const property aparatosAsignados = []
  var property nivelDeDolor
  var property nivelDeFortaleza
  const edad
  method cambiaNivelDeDolor(cantidad) {nivelDeDolor =nivelDeDolor + cantidad}
  method cambiarNivelDeFortaleza(cantidad) {nivelDeFortaleza = nivelDeFortaleza + cantidad}
  method edad() = edad
  method usarAparato(unAparato) {
    if(self.puedeUtilizarAparato(unAparato)){ 
      unAparato.utilizar(self)
    }
  }
  method puedeUtilizarAparato(unAparato) = unAparato.puedeSerUtilizado(self)
  method agregarAparatosAsignado(unAparato){
    aparatosAsignados.add(unAparato)
  }

  method puedeHacerRutina() = aparatosAsignados.all({a=>self.puedeUtilizarAparato(a)})
  method realizarSesion(){
    if(self.puedeHacerRutina()){
      aparatosAsignados.forEach({aparato => self.usarAparato(aparato)})
      aparatosAsignados.forEach({a=>a.desgaste(self)})
    }
  }
  method coloresAparatos() = aparatosAsignados.map({a=>a.color()})
}

class PacienteResistente inherits Paciente {
  override method realizarSesion() {
  super()
  self.cambiarNivelDeFortaleza(aparatosAsignados.size())
}
}

class PacienteCaprichoso inherits Paciente {
  override method puedeHacerRutina() = super() && self.aparatosAsignados().any({a=>a.color() == "rojo"})
  override method realizarSesion() {
    super()
    super()
  }
}

class RapidaRecuperacion inherits Paciente {
  var property alivio = -3
  override method realizarSesion() {
    super()
    self.cambiaNivelDeDolor(alivio)
  }
}


object centro {
  var property pacientes = #{}

  method agregarPaciente(unPaciente) { pacientes.add(unPaciente)}
  method sacarPaciente(unPaciente) { pacientes.remove(unPaciente)}

  method coloresDeAparatos() = pacientes.flatMap({p=>p.coloresAparatos()}).asSet()
  method pacientesMenores() = pacientes.filter({p=>p.edad() < 8})
  method pacientesQueNoCumplen() = pacientes.filter({p=> !p.puedeHacerRutina()}).size()

  method realizarRutinas() = pacientes.forEach({p=>p.realizarSesion()})

  method aparatos() = pacientes.flatMap({p=>p.aparatosAsignados()})

  method optimasCondiciones() = self.aparatos().all({a=>!a.mantenimiento()})
  method complicado() {
    const necesitan = self.aparatos().filter({a=>a.mantenimiento()})
    const noNecesitan = self.aparatos().filter({a=>!a.mantenimiento()})
    return necesitan > noNecesitan
  }
  method visitaTecnico() = self.aparatos().forEach({a=>a.hacerMantenimiento()})
}

class Aparatos {
  var property mantenimiento = false
  var property color = "blanco"
  method utilizar(unPaciente)
  method puedeSerUtilizado(unPaciente) = true
  method cambiarColor(unColor){
    color = unColor
  }
  method desgaste(unPaciente)
  method hacerMantenimiento()
  method mantenimiento() = mantenimiento

}

class Magneto inherits Aparatos {
  var property imantacion = 800
  override method desgaste(unPaciente){
    imantacion = imantacion - 1
  }
  override method hacerMantenimiento() { imantacion = imantacion + 500}
  override method mantenimiento() = imantacion < 100
  
  override method utilizar(unPaciente) {
    unPaciente.cambiaNivelDeDolor(unPaciente.nivelDeDolor() * 0.10)
  }
}

class Bicicleta inherits Aparatos {
  var property cantidadDeDesajuste = 0
  var property cantidadDePerdidaAceite = 0

  override method desgaste(unPaciente){
    self.desajustarTornillo(unPaciente)
    self.perderAceite(unPaciente)
  }
  method desajustarTornillo(alguien){
    if(alguien.nivelDolor() > 30){
        cantidadDeDesajuste += 1
    }
  }
  method perderAceite(alguien){
    if(alguien.edad().between(30, 50)){
        cantidadDePerdidaAceite += 1
    }
  }

  override method mantenimiento() = cantidadDeDesajuste >= 10 or cantidadDePerdidaAceite >= 5
  override method hacerMantenimiento(){
      cantidadDeDesajuste = 0
      cantidadDePerdidaAceite = 0
  }

  override method utilizar(unPaciente)  {
    unPaciente.cambiaNivelDeDolor(-4) 
    unPaciente.cambiarNivelDeFortaleza(3)
  }
  override method puedeSerUtilizado(unPaciente) = unPaciente.edad() > 8
}

class MiniTramp inherits Aparatos {
  override method desgaste(unPaciente) {}
  override method hacerMantenimiento() {}
  override method mantenimiento() = false
  override method utilizar(unPaciente) {
    unPaciente.cambiarNivelDeFortaleza(unPaciente.edad() * 0.10)
  }
  override method puedeSerUtilizado(unPaciente) = unPaciente.nivelDeDolor() < 20
}
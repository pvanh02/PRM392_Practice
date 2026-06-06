// EXERCISE 4: Classes
class Car {
  String brand;

  Car(this.brand);

  Car.named(this.brand);

  void displayInfo() {
    print('Car brand: $brand');
  }
}

class ElectricCar extends Car {
  double batteryCapacity;

  // Subclass constructor using super
  ElectricCar(String brand, this.batteryCapacity) : super(brand);

  // Overriding method
  @override
  void displayInfo() {
    print('Electric Car brand: $brand, Battery: ${batteryCapacity}kWh');
  }
}

void runExercise4() {
  print('========== EXERCISE 4: Intro to OOP ==========');
  
  Car myCar = Car('Toyota');
  myCar.displayInfo();

  Car myNamedCar = Car.named('Honda');
  myNamedCar.displayInfo();

  ElectricCar myElectricCar = ElectricCar('Tesla', 100.0);
  myElectricCar.displayInfo();
  print('');
}

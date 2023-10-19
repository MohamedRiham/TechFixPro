enum ProductName {
  laptop,
  desktop,
  phone,
  tablet,
  monitor,
speaker,
ups,
PcMouse,
camera,
}

const Map<ProductName, int> customProductValues = {
  ProductName.laptop: 0,
  ProductName.desktop: 2,
  ProductName.phone: 4,
  ProductName.tablet: 6,
  ProductName.monitor: 8,
  ProductName.speaker: 10,
  ProductName.ups: 12,
ProductName.PcMouse: 14,
ProductName.camera: 16,
};
enum Problem {
  noPower,
  noDisplay,
  noSound,
notCharging,
powerButtonIsNotWorking,
DoesNotStayOnInBackupMode,
}
const Map<Problem, int> customProblemValues = {
  Problem.noPower: 1,
  Problem.noDisplay: 3,
  Problem.noSound: 5,
  Problem.notCharging: 7,
  Problem.powerButtonIsNotWorking: 9,
 Problem.DoesNotStayOnInBackupMode: 11,
 
};

// Function to map selected product name to ProductName enum value
ProductName mapProductToEnum(String productName) {
  switch (productName) {
    case 'laptop':
      return ProductName.laptop;
    case 'desktop':
      return ProductName.desktop;
    case 'phone':
      return ProductName.phone;
    case 'tablet':
      return ProductName.tablet;
case 'monitor':
      return ProductName.monitor;
case 'speaker':
      return ProductName.speaker;
    case 'ups':
      return ProductName.ups;
case 'PcMouse':
return ProductName.PcMouse;
case 'camera':
return ProductName.camera;
    default:
      throw ArgumentError('Invalid product name: $productName');
  }
}

Problem mapProblemToEnum(String problem) {
  switch (problem) {
    case 'noPower':
      return Problem.noPower;
    case 'noDisplay':
      return Problem.noDisplay;
    case 'noSound':
      return Problem.noSound;
    case 'notCharging':
      return Problem.notCharging;
    case 'powerButtonIsNotWorking':
      return Problem.powerButtonIsNotWorking;
    case 'DoesNotStayOnInBackupMode':
      return Problem.DoesNotStayOnInBackupMode;

    default:
      throw ArgumentError('Invalid product problem: $problem');
  }
}


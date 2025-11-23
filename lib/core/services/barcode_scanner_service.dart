import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerService {
  MobileScannerController? _controller;

  // Create scanner controller
  MobileScannerController createController({
    bool autoStart = true,
    DetectionSpeed detectionSpeed = DetectionSpeed.normal,
    CameraFacing facing = CameraFacing.back,
    bool torchEnabled = false,
  }) {
    _controller = MobileScannerController(
      autoStart: autoStart,
      detectionSpeed: detectionSpeed,
      facing: facing,
      torchEnabled: torchEnabled,
    );
    return _controller!;
  }

  // Get current controller
  MobileScannerController? get controller => _controller;

  // Start scanning
  Future<void> start() async {
    if (_controller != null) {
      await _controller!.start();
    }
  }

  // Stop scanning
  Future<void> stop() async {
    if (_controller != null) {
      await _controller!.stop();
    }
  }

  // Toggle torch (flashlight)
  Future<void> toggleTorch() async {
    if (_controller != null) {
      await _controller!.toggleTorch();
    }
  }

  // Switch camera
  Future<void> switchCamera() async {
    if (_controller != null) {
      await _controller!.switchCamera();
    }
  }

  // Dispose controller
  void dispose() {
    _controller?.dispose();
    _controller = null;
  }

  // Parse barcode result
  String? parseBarcodeValue(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return null;

    final barcode = barcodes.first;
    return barcode.rawValue;
  }

  // Get barcode type
  BarcodeType? getBarcodeType(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return null;

    final barcode = barcodes.first;
    return barcode.type;
  }
}

// Provider
final barcodeScannerServiceProvider = Provider<BarcodeScannerService>((ref) {
  return BarcodeScannerService();
});

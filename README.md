# Missionware.LibWebRtcSharp

**Missionware.LibWebRtcSharp** is a collection of .NET bindings and wrappers for **WebRTC** native libraries across multiple platforms. This project provides production-ready NuGet packages that enable real-time communication capabilities in .NET applications, including support for video, audio, and data channels.

Each platform-specific package includes:
- **Prebuilt native WebRTC binaries** from trusted upstream sources
- **Platform-specific binding layers** (Java/Kotlin for Android, Objective-C for iOS)
- **Automatic build integration** - no manual configuration required
- **Compatible with .NET for Android/iOS and .NET MAUI**

---

## 📦 Available Packages

| Platform | Package | WebRTC Source | Status |
|----------|---------|---------------|--------|
| **Android** | `Missionware.LibWebRtcSharp.Android` | [GetStream/webrtc-android](https://github.com/GetStream/webrtc-android) | ✅ Available |
| **iOS** | `Missionware.LibWebRtcSharp.iOS` | _Coming soon_ | 🚧 Planned |
| **Windows** | `Missionware.LibWebRtcSharp.Windows` | _Coming soon_ | 🚧 Planned |

---

## 📱 Android

### Overview

**Missionware.LibWebRtcSharp.Android** provides prebuilt **WebRTC native binaries for Android** from [GetStream/webrtc-android](https://github.com/GetStream/webrtc-android), packaged as a reusable NuGet for .NET for Android / MAUI Android projects.

It includes the **Java glue layer** (AAR) required by Android bindings and automatically wires everything into your build.

| Component | Source | WebRTC Milestone | Stream Version | License |
|------------|--------|------------------|----------------|----------|
| AAR | [GetStream/webrtc-android](https://github.com/GetStream/webrtc-android) | m125 | 1.3.10 | BSD + Google IP Grant |

**Features:**
- Contains the **native `libjingle_peerconnection_so.so`** binaries for all supported ABIs.
- Includes Java classes and manifest metadata from the AAR.
- Automatically merges manifests, includes ProGuard/R8 rules, and loads JNI libs by ABI.
- Compatible with **.NET 9 for Android** and **.NET MAUI Android**.

### Versioning Scheme

NuGet version `1.12510310.0` encodes both WebRTC milestone and Stream version:

```
1.M[milestone]V[stream-version].P[patch]
  │ │          │                 │
  │ │          │                 └─ Patch version (0)
  │ │          └─────────────────── Stream version (310 → 1.3.10)
  │ └────────────────────────────── WebRTC milestone (12510 → m125.10)
  └──────────────────────────────── Major version prefix (1)
```

### Installation

Install via NuGet Package Manager or .NET CLI:

```bash
dotnet add package Missionware.LibWebRtcSharp.Android
```

Or add to your `.csproj`:

```xml
<PackageReference Include="Missionware.LibWebRtcSharp.Android" Version="1.12510310.0" />
```

### Usage

Once installed, the WebRTC Java bindings are automatically available in your .NET for Android project under the `Org.Webrtc` namespace:

```csharp
using Org.Webrtc;

// Initialize PeerConnectionFactory
var options = PeerConnectionFactory.InitializationOptions.InvokeBuilder(context)
    .SetEnableInternalTracer(true)
    .CreateInitializationOptions();

PeerConnectionFactory.Initialize(options);

// Create PeerConnectionFactory
var factory = PeerConnectionFactory.InvokeBuilder()
    .SetVideoEncoderFactory(new DefaultVideoEncoderFactory(eglBase.EglBaseContext, true, true))
    .SetVideoDecoderFactory(new DefaultVideoDecoderFactory(eglBase.EglBaseContext))
    .CreatePeerConnectionFactory();
```

For complete examples and documentation, see the [Android project README](Missionware.LibWebRtcSharp.Android/README.md).

---

## 📄 License

**BSD 3-Clause License**  
Copyright (c) 2025 Missionware  
All rights reserved.

This project redistributes open-source WebRTC components:
- **WebRTC** (BSD 3-Clause + Google Patent Grant) from [webrtc.org](https://webrtc.org)
- **GetStream/webrtc-android** (Apache 2.0) from [GetStream](https://github.com/GetStream/webrtc-android)

See [LICENSE](LICENSE) for full details and [Android LICENSES.md](Missionware.LibWebrtcSharp.Android/LICENSES.md) for third-party attributions.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

---

## 🔗 Resources

- [WebRTC Official Documentation](https://webrtc.org/)
- [GetStream WebRTC Android](https://github.com/GetStream/webrtc-android)
- [.NET MAUI Documentation](https://learn.microsoft.com/dotnet/maui/)
- [.NET for Android Documentation](https://learn.microsoft.com/dotnet/android/)


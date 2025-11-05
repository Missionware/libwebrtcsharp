# Missionware.LibWebrtcSharp.Android

**Missionware.LibWebrtcSharp.Android** provides prebuilt **WebRTC native binaries for Android** from [GetStream/webrtc-android](https://github.com/GetStream/webrtc-android), packaged as a reusable NuGet for .NET for Android / MAUI Android projects.

It includes the **Java glue layer** (AAR) required by Android bindings and automatically wires everything into your build.

---

## ⚙️ Overview

| Component | Source | WebRTC Milestone | Stream Version | License |
|------------|--------|------------------|----------------|----------|
| AAR | [GetStream/webrtc-android](https://github.com/GetStream/webrtc-android) | m125 | 1.3.10 | BSD + Google IP Grant |

- Contains the **native `libjingle_peerconnection_so.so`** binaries for all supported ABIs.
- Includes Java classes and manifest metadata from the AAR.
- Automatically merges manifests, includes ProGuard/R8 rules, and loads JNI libs by ABI.
- Compatible with **.NET 8 for Android** and **.NET MAUI Android**.

---

## 🧩 Versioning scheme

NuGet version `1.12510310.0` encodes both WebRTC milestone and Stream version:


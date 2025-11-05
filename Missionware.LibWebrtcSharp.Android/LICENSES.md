# Missionware.LibWebrtcSharp.Android — License Summary

**Primary License:** [BSD 3-Clause License](licenses/LICENSE-BSD.txt)  
Copyright (c) 2025 Missionware  
All rights reserved.

This repository packages the Android build of [GetStream/webrtc-android](https://github.com/GetStream/webrtc-android),
which includes prebuilt binaries of [Google WebRTC](https://webrtc.org) (milestone 125) with patches from [webrtc-sdk/webrtc](https://github.com/webrtc-sdk/webrtc).

The project redistributes several open-source components.  
Each component retains its original license, reproduced in the [`/licenses`](licenses/) folder.

---

## 📋 License Overview

| Component | Source | License | Notes |
|------------|---------|----------|-------|
| **Missionware.LibWebrtcSharp.Android** | Missionware | BSD 3-Clause | Wrapper and NuGet packaging |
| **WebRTC** | [webrtc.org](https://webrtc.org) | BSD 3-Clause + [Google IP Grant](licenses/LICENSE-Google-IP-Grant.txt) | Core native engine |
| **webrtc-sdk/webrtc** | [github.com/webrtc-sdk/webrtc](https://github.com/webrtc-sdk/webrtc) | BSD 3-Clause | Build system and native patches |
| **shiguredo/webrtc** | [github.com/shiguredo/webrtc](https://github.com/shiguredo/webrtc) | Apache 2.0 | Additional patches (via GetStream) |
| **GetStream/webrtc-android** | [github.com/GetStream/webrtc-android](https://github.com/GetStream/webrtc-android) | Apache 2.0 | AAR and Java glue layer |
| **AndroidX dependencies (if any)** | Google / Jetpack | Apache 2.0 | Runtime support libraries |

Full license texts are provided under the [`/licenses`](licenses/) directory.

---

## ⚙️ Codec and Redistribution Notice

- This package **does not include** any software implementations of H.264/AVC, OpenH264, x264, or FFmpeg.  
- All H.264/AVC functionality is handled by the **Android operating system’s MediaCodec hardware**.  
- VP8, VP9, and Opus codecs are part of the standard WebRTC stack under BSD terms.

Redistribution and use are permitted under the BSD 3-Clause terms.  
See [`licenses/LICENSE-BSD.txt`](licenses/LICENSE-BSD.txt) for full text.

---

## 🧠 SPDX Summary

```
SPDX-PackageName: Missionware.LibWebrtcSharp.Android
SPDX-PackageVersion: 1.12510310.0
SPDX-PackageSupplier: Organization: Missionware
SPDX-PackageLicenseConcluded: BSD-3-Clause
SPDX-PackageLicenseDeclared: BSD-3-Clause
SPDX-FilesAnalyzed: false
SPDX-PackageComment: This package redistributes WebRTC binaries (BSD-3-Clause + Google Patent Grant) and GetStream/webrtc-android components (Apache-2.0).


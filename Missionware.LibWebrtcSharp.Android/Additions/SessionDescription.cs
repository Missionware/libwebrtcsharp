using Android.Runtime;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Org.Webrtc
{
    public partial class SessionDescription
    {
        public SessionDescription.Type? TypeEnum
        {
            get
            {
                const string __id = "type.Lorg/webrtc/SessionDescription$Type;";
                var handle = _members.InstanceFields.GetObjectValue(__id, this);
                return Java.Lang.Object.GetObject<SessionDescription.Type>(
                    handle.Handle,
                    JniHandleOwnership.TransferLocalRef
                );
            }
        }
    }
}


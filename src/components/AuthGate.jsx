import { useEffect, useState } from 'react';
import { auth, RecaptchaVerifier } from '../firebase';
import { signInWithPhoneNumber, onAuthStateChanged } from 'firebase/auth';

export default function AuthGate({ children }) {
  const [user, setUser] = useState(null);
  const [otpSent, setOtpSent] = useState(false);
  const [confirmation, setConfirmation] = useState(null);
  const [phone, setPhone] = useState('');
  const [otp, setOtp] = useState('');

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, u => setUser(u));
    return unsub;
  }, []);

  const sendOTP = async () => {
    const verifier = new RecaptchaVerifier('recaptcha-container', { size: 'invisible' }, auth);
    const conf = await signInWithPhoneNumber(auth, phone, verifier);
    setConfirmation(conf);
    setOtpSent(true);
  };

  const verifyOTP = async () => {
    await confirmation.confirm(otp);
  };

  if (!user) {
    return (
      <div>
        {!otpSent ? (
          <div>
            <input value={phone} onChange={e => setPhone(e.target.value)} placeholder="Phone" />
            <div id='recaptcha-container'></div>
            <button onClick={sendOTP}>Send OTP</button>
          </div>
        ) : (
          <div>
            <input value={otp} onChange={e => setOtp(e.target.value)} placeholder="OTP" />
            <button onClick={verifyOTP}>Verify OTP</button>
          </div>
        )}
      </div>
    );
  }
  return children;
}

import { useEffect, useRef, useState } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { fetchNui } from "../utils/fetchNui";
import CircularProgress from '@mui/joy/CircularProgress';

const Loading = () => {
  let timerInterval = useRef<NodeJS.Timeout | null>(null);
  const [visible, setVisible] = useState(false);

  const handleStopLoading = (success: boolean) => {
    setVisible(false);
    if (timerInterval.current) clearInterval(timerInterval.current);
    fetchNui("loadingStopped", success);
  };

  useNuiEvent("startLoading", (data) => {
    setVisible(true);

    if (data.time === null) return;
    let timeLeft = data.time;

    timerInterval.current = setInterval(() => {
      timeLeft -= 1000;
      if (timeLeft <= 0) {
        if (timerInterval.current) clearInterval(timerInterval.current);
        handleStopLoading(true);
      }
    }, 1000);
  });

  useNuiEvent("stopLoading", handleStopLoading);

  return (
    visible && (
      <div className="w-screen h-screen flex justify-center items-center bg-black/50">
        <CircularProgress variant="soft" color="primary" size="md" />
      </div>
    )
  );
};

export default Loading;

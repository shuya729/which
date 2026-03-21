const getRequiredEnv = (name: string): string => {
  const value = process.env[name];

  if (!value) {
    throw new Error(
      `Missing required environment variable: ${name}. ` +
        "Set it in functions/.env before running Firebase."
    );
  }

  return value;
};

export const getOpenAIApiKey = (): string => getRequiredEnv("OPENAI_API_KEY");

export const getLineChannelAccessToken = (): string =>
  getRequiredEnv("LINE_CHANNEL_ACCESS_TOKEN");

export const getLinePushUserId = (): string =>
  getRequiredEnv("LINE_PUSH_USER_ID");

data {
  int<lower=0> N_observations;           // Number of data points
  int<lower=0> N_states;                 // Number of states
  array[N_observations] int samplesize;
  array[N_observations] int state_idx;
  array[N_observations] int y_clinton;
  array[N_observations] int y_trump;
  array[N_observations] int y_johnson;
}


parameters {
  vector<lower=0, upper=1>[N_states] a;
  vector<lower=0, upper=1>[N_states] b;
}


transformed parameters {
  vector[N_states] theta_clinton;
  vector[N_states] theta_trump;
  vector[N_states] theta_johnson;
  
  for (n in 1:N_states) {
    theta_clinton[n] = a[n];
    theta_trump[n] = b[n]*(1-a[n]);
    theta_johnson[n] = 1 - a[n] - b[n]*(1-a[n]);
  }
}


model {
  // Priors
  a[state_idx] ~ beta(2,2);
  b[state_idx] ~ beta(9,1);
  
  // Likelihood
  y_clinton ~ binomial(samplesize, theta_clinton[state_idx]);
  y_trump ~ binomial(samplesize, theta_trump[state_idx]);
  y_johnson ~ binomial(samplesize, theta_johnson[state_idx]);
}

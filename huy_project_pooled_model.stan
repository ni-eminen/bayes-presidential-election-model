data {
  int<lower=0> N_observations;           // Number of data points
  int<lower=0> N_states;                 // Number of states
  array[N_observations] int samplesize;
  array[N_observations] int state_idx;
  array[N_observations] int y_clinton;
  array[N_observations] int y_trump;
  //array[N_observations] int y_johnson;
}


parameters {
  real<lower=0, upper=1> a;
  real<lower=0, upper=1> b;
}


transformed parameters {
  vector[N_states] theta_clinton;
  vector[N_states] theta_trump;
  //vector[N_states] theta_johnson;
  
  for (n in 1:N_states) {
    theta_clinton[n] = a;
    theta_trump[n] = b*(1-a);
    //theta_johnson[n] = 1 - a - b*(1-a);
  }
}


model {
  // Priors
  a ~ beta(2,2);
  b ~ beta(9,1);
  
  // Likelihood
  y_clinton ~ binomial(samplesize, theta_clinton[state_idx]);
  y_trump ~ binomial(samplesize, theta_trump[state_idx]);
  //y_johnson ~ binomial(samplesize, theta_johnson[state_idx]);
}


generated quantities {
  vector[N_observations] theta_clinton_pred;
  vector[N_observations] theta_trump_pred;
  for (n in 1:N_observations) {
    theta_clinton_pred[n] = binomial_rng(samplesize[n], theta_clinton[state_idx[n]])*1.0/samplesize[n];
    theta_trump_pred[n] = binomial_rng(samplesize[n], theta_trump[state_idx[n]])*1.0/samplesize[n];
  }
}


# SOST20131 / SOST30031 16/10/2026
# WEEK 3 PRACTICAL: CAUSAL DAGs WITH DAGITTY
#
# The focus is causal reasoning: confounders, mediators, colliders,
# backdoor paths, and adjustment sets.


# ============================================================
# SESSION AIMS
# ============================================================
# By the end of this practical, you should be able to:
#
# 1. Represent causal assumptions using a directed acyclic graph (DAG).
# 2. Distinguish confounders, mediators, and colliders.
# 3. Identify backdoor paths between an exposure and an outcome.
# 4. Use Dagitty to identify sufficient adjustment sets.
# 5. Explain why adjusting for every available variable can be a mistake.


# ============================================================
# 0. SET-UP
# ============================================================
# We will use the R package "dagitty".
#
# Install this package ONLY if you do not already have it:

install.packages("dagitty")
library(dagitty)

# You can also explore the same DAGs visually using the Dagitty web interface:
# https://dagitty.net/dags.html


# ============================================================
# RESEARCH QUESTION
# ============================================================
# We will use one substantive question throughout:
#gb

#   What is the TOTAL causal effect of education on earnings?
#
# Exposure: Education
# Outcome: Earnings
#
# IMPORTANT:
# A DAG does not prove that the arrows are correct.
# It represents the causal assumptions we are making.


# ============================================================
# 1. A SIMPLE DAG: CONFOUNDING
# ============================================================
# Suppose parental socioeconomic position (Parental_SES) affects both:
#   - a person's education
#   - their later earnings
#
# Complete the DAG below by adding the missing arrows.
#
# Expected causal assumptions:
#   Parental_SES -> Education
#   Parental_SES -> Earnings
#   Education -> Earnings

dag1 <- dagitty('dag {
  Education [exposure]
  Earnings [outcome]

  Parental_SES -> Education
  Parental_SES -> Earnings
  Education -> Earnings

}')

plot(dag1)


# QUESTIONS
#
# Q1. What is the causal path from Education to Earnings?
#   --Education → Earnings
# Q2. Is there a backdoor path between Education and Earnings?
#     If yes, write it down.
#   --Education ← Parental_SES → Earnings
# Q3. Which variable is the confounder?
#   --Parental_SES
# Q4. Before asking Dagitty, which variable do you think we should adjust for?
#   --Parental_SES
# Now ask Dagitty:
adjustmentSets(dag1)
#
# Q5. Does Dagitty agree with your answer?
#   --yes
# Optional: list the paths between Education and Earnings.
paths(dag1, from = "Education", to = "Earnings")


# ============================================================
# 2. ADDING A MEDIATOR
# ============================================================
# Now suppose education affects occupation, which then affects earnings.
#
# Add Occupation as a mediator:
#
#   Education -> Occupation -> Earnings
#
# Keep the relationships from DAG 1.

dag2 <- dagitty('dag {
  Education [exposure]
  Earnings [outcome]

  Parental_SES -> Education
  Parental_SES -> Earnings
  Education -> Earnings

  Occupation
  Education -> Occupation
  Occupation -> Earnings

}')

plot(dag2)


# QUESTIONS
#
# Q6. What role does Occupation play in this DAG?
#   --Mediator
# Q7. We want the TOTAL effect of Education on Earnings.
#     Should we adjust for Occupation? Why or why not?
#   --- NO
# Q8. Ask Dagitty for a sufficient adjustment set.
adjustmentSets(dag2)
#
# Q9. Is Occupation included in the adjustment set?
#   ---no
# Q10. What part of the causal effect would we remove if we controlled
#      for Occupation?
#    --indirect effect

# ============================================================
# 3. ADDING A COLLIDER
# ============================================================
# Now consider employment status.
#
# Suppose:
#   Education -> Employment
#   Health -> Employment
#   Health -> Earnings
#
# Employment is therefore a common effect of Education and Health.
#
# Complete the DAG.

dag3 <- dagitty('dag {
  Education [exposure]
  Earnings [outcome]

  Parental_SES -> Education
  Parental_SES -> Earnings

  Education -> Earnings
  Education -> Occupation
  Occupation -> Earnings

  
   Education -> Employment
   Health -> Employment
   Health -> Earnings

}')


# QUESTIONS
#
# Q11. What role does Employment play on the path:
#
#      Education -> Employment <- Health -> Earnings
#
# Q12. Is this path open or closed if we do NOT condition on Employment?
#
# Q13. What can happen if we control for Employment?
#
# Q14. Imagine that our dataset contains earnings only for people who are
#      currently employed. Why could this create a problem?
#
# Now ask Dagitty for an adjustment set for the TOTAL effect:

#
# Q15. Does Dagitty tell us to adjust for:
#      (a) Parental_SES?
#      (b) Occupation?
#      (c) Employment?
#
# Explain each answer using the terms confounder, mediator, and collider.


# ============================================================
# 4. EXTENSION: MODIFY THE DAG
# ============================================================
# Choose ONE of the following:
#
# A. Add Age as a common cause of Education and Earnings.
# B. Add Ability as a common cause of Education and Earnings
